# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`newsmlg2` — a lutaml-model-based Ruby object model for IPTC **NewsML-G2** (News Architecture, NAR): parse, manipulate, build (DSL), and serialize NewsML-G2 XML with round-trip fidelity. Targets spec version **2.35**, **power** conformance. Namespace: `Newsmlg2`.

Implementation is driven by the ordered plan files in **`TODO.impl/`** (`01-…` through `13-…`). Execute them in order; each is self-contained with references, deliverables, and acceptance criteria.

## Reference codebases — READ, do not guess

Four local checkouts are the authority for this port. Consult them before designing anything:

| Path | Role |
|---|---|
| `/Users/mulgogi/src/external/python-newsmlg2/` | Reference implementation (Python, lxml). ~317 model classes in `NewsMLG2/*.py`; its `tests/` (11 files, 35 tests, 13 fixtures in `tests/test_files/`) must be **ported fully and pass**. |
| `/Users/mulgogi/src/external/newsml-g2/` | **Official IPTC spec repo** (git@github.com:iptc/newsml-g2). XSDs in `specification/` and `tests/schema_versions/`; 31 example listings in `examples/`; official unit-test suite: 161 XML files in `tests/unit_test_files/{version}/should_pass|should_fail/` run by `tests/runtests.py`. All are compliance fixtures for our specs. |
| `/Users/mulgogi/src/lutaml/chemicalml/` | Sibling gem whose **gemspec, GitHub workflows, and architecture we fully adopt** (gemspec, `.github/workflows/rake.yml`+`release.yml`, `Base::*` mixin pattern, canon-based round-trip specs). |
| `/Users/mulgogi/src/mn/metanorma-document/` | lutaml-model usage reference. NOTE: it has **no builder DSL** — the NewsML builder DSL is designed in `TODO.impl/12-builder-dsl.md`, generated generically from model metadata. |

Ground truth on NewsML-G2 semantics (item types, itemMeta/contentMeta/partMeta, catalog/scheme/qcode system, conformance levels): the 2.35 XSDs in the official repo (`specification/individual/NewsML-G2_2.35-spec-Framework-Power.xsd` is the core, 5.3k lines).

## Commands

```sh
bundle install                      # deps: lutaml-model ~> 0.8, dev: rspec, rubocop, nokogiri, canon, simplecov
bundle exec rake                    # default task = rspec
bundle exec rspec                   # full suite
bundle exec rspec spec/newsmlg2/catalog_spec.rb          # one file
bundle exec rspec spec/newsmlg2/catalog_spec.rb:42       # one example by line
bundle exec rspec -e "round trips"                        # by description
bundle exec rubocop                 # lint (TargetRubyVersion 3.3, NewCops: enable)
bundle exec rubocop -a              # safe autocorrect
```

RSpec config lives in `spec/spec_helper.rb` (no `.rspec` file): nokogiri XML adapter, canon semantic-XML comparison (`be_xml_equivalent_to`, wrap compared docs in `<r>…</r>`), random order, focus filtering.

Never modify vendored fixture files under `spec/fixtures/` (copied from the reference repos); regenerate/copy anew if needed.

## Architecture

### Model layer (chemicalml pattern)

One Ruby class per NewsML-G2 complex type, `snake_case` file per class under `lib/newsmlg2/`, all wired with `autoload` from `lib/newsmlg2.rb` (never `require_relative`).

- **`Base::*` modules** (`lib/newsmlg2/base/`) — one per XSD *attribute group* (`CommonPowerAttributes`, `I18NAttributes`, `FlexAttributes`, …) and per shared *element group* (`ItemManagementGroup`, `DescriptiveMetadataGroup`, `ConceptRelationshipsGroup`, …). Each declares its `attribute`s and appends mappings via a `self.included(klass)` hook — this is how python-newsmlg2's multiple-inheritance MRO merging translates to Ruby mixins.
- **Wire classes** — thin: `class NewsItem < Lutaml::Model::Serializable; include Base::…; include …; end` with their `xml do … end` mapping (`root`, `map_element`, `map_attribute`, `map_content`).
- **Namespaces** — `Newsmlg2::NarNamespace` (`http://iptc.org/std/nar/2006-10-01/`, default/unprefixed) and `Newsmlg2::NitfNamespace`; `xml:lang`/`xml:base` attributes come from `Lutaml::Xml::W3c::XmlNamespace`. Set via `namespace` in the `xml` block.
- **xs:any / unknown children** — captured with `map_all` (raw round-trip), replacing python-newsmlg2's `ExtensionElement`/`_xs_any_content`.
- All serialization goes through lutaml-model mappings. **Never** hand-roll `to_h`/`from_h`/`to_xml` on model classes.

### Subsystems

- **`Newsmlg2::Document`** — entry point mirroring python's `NewsMLG2Document`: `Newsmlg2.parse(xml)` / `parse_file(path)` → detects root element (`newsItem`, `packageItem`, `conceptItem`, `knowledgeItem`, `catalogItem`, `planningItem`, `newsMessage`) → typed item; `#item`/`#item=`; `#to_xml` with declaration, NAR default ns, `nitf` + `xml` prefixes; writes required defaults (`standard="NewsML-G2" standardversion="2.35" conformance="power" version="1"`).
- **Catalog system** — `CatalogStore` (per-document), `Catalog`/`CatalogRef`/`Scheme`, bundled IPTC catalogs (`lib/newsmlg2/catalogs/*.xml`, v32–v41), `Newsmlg2.qcode_to_uri` / `uri_to_qcode`, errors `AliasNotFoundInCatalogs` / `URINotFoundInCatalogs`.
- **Builder DSL** — `Newsmlg2.build_news_item(guid: …, lang: "en-GB") { |item| … }` (one `build_*` per item type). Node proxies are **generated from the model's lutaml attribute metadata** (snake_case methods, value coercion String→content-model, nested blocks, repeatable calls for collections). No per-class hand-written builder code.

### Test tiers (all must stay green)

1. **Ported python suite** — `spec/newsmlg2/**` mirroring `python-newsmlg2/tests/test_*.py` one-to-one (semantics preserved, Ruby idioms).
2. **IPTC examples** — `spec/compliance/examples_spec.rb` over vendored `spec/fixtures/iptc/examples/` (31 LISTING files + extras): parse → typed assertions → semantic round-trip via canon.
3. **IPTC official validation suite** — `spec/compliance/xsd_validation_spec.rb` over `spec/fixtures/iptc/unit_test_files/` (151 should-pass / 10 should-fail) × per-version XSDs from `tests/schema_versions/`, using `Lutaml::Xml::XsdValidator`; the file→schema matrix mirrors `tests/runtests.py` exactly.

## Conventions

- Specs use **real model instances — never doubles**; assert behavior and output, not interactions.
- Gemspec/workflows follow chemicalml verbatim (adapted names): `required_ruby_version >= 3.3.0`, single runtime dep `lutaml-model ~> 0.8.0`, `BSD-2-Clause`, Ribose Inc.
- Versions, tags, and releases are **the user's decision** — the release workflow is manually dispatched; never pick a version number.
- All changes go through PRs; never commit/push to main or push tags.
