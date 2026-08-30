# 02 — lutaml-model foundation spike

Depends on: 01.

## Goal

Prove, with executable spike specs, every non-trivial lutaml-model idiom this
port depends on **before** mass-authoring ~317 model classes. Each confirmed
idiom becomes the canonical pattern used by plans 03–09.

The installed reference is lutaml-model 0.8.22 at
`/Users/mulgogi/.local/share/mise/installs/ruby/3.4.8/lib/ruby/gems/3.4.0/gems/lutaml-model-0.8.22/`
(read its `lib/lutaml/xml/` sources; specs in the gem's `spec/` if vendored).

## Questions to answer (each = one spike spec, kept in `spec/newsmlg2/foundation/`)

1. **Default namespace.** Define
   `Newsmlg2::NarNamespace < Lutaml::Xml::Namespace` with
   `uri "http://iptc.org/std/nar/2006-10-01/"` and a **default (unprefixed)**
   declaration (`prefix_default` unset/nil — inspect how `Namespace` and the
   Nokogiri adapter emit `xmlns="…"` vs `xmlns:prefix="…"`). Parse and
   re-serialize `<newsItem xmlns="http://iptc.org/std/nar/2006-10-01/"/>`;
   confirm the default xmlns round-trips.
2. **xml: attributes.** Map `xml:lang` / `xml:base` using
   `Lutaml::Xml::W3c::XmlNamespace` (see `lib/lutaml/xml/w3c.rb`). Find the
   correct DSL (likely `namespace_scope` on the model or per-attribute
   namespace). Confirm parse/serialize of `xml:lang="en-GB"` and that the
   serializer never emits a redundant `xmlns:xml` declaration.
3. **Raw catch-all (xs:any).** `map_all to: :extension_content` (see
   `lib/lutaml/xml/mapping.rb`, `map_all`/`map_all_content`): parse an element
   containing undeclared children in other namespaces (e.g. inline `nitf:body`),
   confirm the raw fragment is preserved byte-exactly through round-trip, and
   how declared siblings + map_all coexist. This replaces python-newsmlg2's
   `ExtensionElement`/`_xs_any_content`.
4. **Mixed content + text.** `mixed_content true` + `map_content to: :text,
   collection: true` for label types (`block`, `span`, `ruby`, `a`) where text
   interleaves with child elements (python-newsmlg2 leaves this TODO — we must
   do better). Confirm interleaved text/children round-trip.
5. **Default attribute rendering.** Items must serialize
   `standard="NewsML-G2" standardversion="2.35" conformance="power" version="1"`
   even when unset, exactly like python-newsmlg2's `to_xml`. Test
   `attribute :standard, :string, default: "NewsML-G2"` +
   `map_attribute "standard", to: :standard, render_default: true` (check the
   real option name in `mapping.rb` / `mapping_rule.rb`: `render_default`,
   `default_method`, or `with: { to: … }`). Confirm output order of attributes
   matches expectation (python writes them in declaration order:
   `standard`, `standardversion`, `conformance`, `guid`, `version`).
6. **Choice / polymorphic content.** `contentSet` is a choice of `inlineXML` |
   `remoteContent+`; `conceptId` is a choice of `conceptURI`|`conceptQCode`|…
   Investigate `polymorphic_value_handler.rb` and any `map_element` choice
   support. Pick the idiom: polymorphic mapping if supported, else
   optional-attributes + a validating `#validate` hook. Document the choice.
7. **Mapping composition from mixins.** Confirm how included modules contribute
   mappings: look at `ensure_mappings_imported!`, `consolidation_maps`,
   `import_mappings` (or equivalent) in `lib/lutaml/xml/mapping.rb`, and
   chemicalml's `Base::CommonChildren` mixin
   (`/Users/mulgogi/src/lutaml/chemicalml/lib/chemicalml/cml/base/common_children.rb`).
   Reproduce the chemicalml pattern: a module whose `self.included(klass)`
   declares `attribute`s and appends `map_element`/`map_attribute` rules to the
   including class's `xml` mapping. This is the load-bearing mechanism for
   plans 03–08 — do not proceed until it is proven with a two-level example.
8. **Output formatting.** `to_xml(pretty: true)`: exact declaration line,
   quoting style, trailing newline, namespace-declaration placement. Record the
   exact canonical output of a minimal `<newsItem …/>`; plan 10's byte-compare
   test will assert against our own canonical form.
9. **XSD validation.** `Lutaml::Xml::XsdValidator.validate(xml, schema_paths)`
   (and the `validate_xml_with` class macro) against a copy of the official
   2.35 All-Power XSD — used by plan 12.

## Deliverables

- `spec/newsmlg2/foundation/*_spec.rb` — one spec per question above, all green.
- `lib/newsmlg2/namespaces.rb` + `nar.rb`/`nitf.rb` namespace classes (real,
  they are keepers) — `NarNamespace` (default prefix) and `NitfNamespace`
  (`uri "http://iptc.org/std/NITF/2006-10-18/"`, prefix `nitf`).
- Update this file's "Confirmed patterns" section below with the verified DSL
  forms, so downstream plans copy them verbatim.

## Acceptance

- All foundation specs pass.
- "Confirmed patterns" section documents each idiom with a 3–10 line code
  snippet taken from the passing specs.

## Confirmed patterns

Verified against lutaml-model **0.8.22** (specs in `spec/newsmlg2/foundation/`, all green):

1. **Namespace** — `Newsmlg2::NarNamespace < Lutaml::Xml::Namespace` with
   `uri "http://iptc.org/std/nar/2006-10-01/"` + `element_form_default :qualified`.
   Qualified form makes child elements inherit the default xmlns (no `xmlns=""`
   resets, no redundant declarations). `NitfNamespace` uses `prefix_default "nitf"`.

2. **Model base** — every NAR model extends `Newsmlg2::NarModel < Lutaml::Model::Serializable`,
   which declares `xml { namespace Newsmlg2::NarNamespace }` once. Subclasses only
   declare `element "itemMeta"` + `map_*` rules; namespace inherited transitively.

3. **xml: attributes** — typed via `Newsmlg2::Types::XmlLang < Lutaml::Model::Type::String`
   with `xml { namespace Lutaml::Xml::W3c::XmlNamespace }`; declared as
   `attribute :lang, Types::XmlLang` + `map_attribute "lang", to: :lang`. Serializes
   as `xml:lang="…"` with no `xmlns:xml` declaration.

4. **Group composition** — `Base::*` mixins use `self.included(klass)` →
   `klass.class_eval { attribute …; xml { map_* … } }`. lutaml-model accumulates
   xml mappings across included modules, superclass, and the class's own `xml`
   block; serialized child order follows declaration/include order.

5. **Required defaults** — `attribute :standard, :string, default: -> { "NewsML-G2" }`
   + `map_attribute "standard", to: :standard, render_default: true` renders the
   default even when unset. Attribute emission order = declaration order.

6. **Raw foreign content** — `map_all to: :content` captures undeclared children
   (foreign namespaces, e.g. NITF inside `inlineXML`) as a raw string; re-serialized
   via parsed fragment (semantic round-trip equivalence holds). NOTE: unprefixed
   foreign children inherit the surrounding default NAR namespace — always parse
   with the document's real default namespace (real NewsML files always have it).

7. **Choices** — modeled as optional attributes (e.g. contentSet's inlineXML |
   remoteContent+); mutual exclusion is enforced by the XSD, not the object model.

8. **Output** — `to_xml` is pretty by default (2-space indent);
   `to_xml(declaration: true)` prepends `<?xml version="1.0" encoding="UTF-8"?>`.
   Canonical output form is deterministic → byte-compare against our own output.

9. **Comparison** — canon pinned to **0.2.12** (0.3.8 dropped `:spec_friendly`
   and has a diff-generator bug). Config in `spec/spec_helper.rb`; compare
   fragments wrapped in `<r>…</r>`; comparison is whitespace-insensitive but
   namespace-sensitive.

10. **Parse tolerance** — unknown child elements are silently skipped on parse
    (mirrors python's extension capture being best-effort; the XSD suite is the
    authoritative validity gate).


## Risks

- If `map_all` cannot coexist with declared elements on the same class,
  fallback: a custom `Raw` type attribute capturing remaining children via the
  Nokogiri adapter at parse time (`with: { from: …, to: … }` hooks) — decide in
  the spike, not later.
- If mixin mapping composition is not supported, plans 03–08 will instead use
  inheritance chains (`class ContentMetaAfDType < ContentMetadataAcDType`),
  mirroring the XSD type hierarchy directly. Decide here.
