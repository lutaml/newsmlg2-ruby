# 10 — Port the full python-newsmlg2 test suite

Depends on: 09 (all models + entry point complete).

## Goal

Port **every** test from `/Users/mulgogi/src/external/python-newsmlg2/tests/`
(11 files, 35 test functions) to RSpec, preserving semantics 1:1 where the
languages allow, and making every ported example pass. No skips except with a
documented reason appended to this file.

## Fixtures to vendor

Copy verbatim into `spec/fixtures/python/test_files/` (never modify):
`001_simplest_file.xml` … `008_roundtrip_test.xml`,
`LISTING_1_…`, `LISTING_3_…`, `LISTING_6_…`, `LISTING_13_…`,
`LISTING_19_…` (13 files, from python `tests/test_files/`).

## File-by-file port map

| Python test | RSpec | Notes |
|---|---|---|
| `test_autoloader.py` | `spec/newsmlg2/autoload_spec.rb` | python's `import_string` lazy-class trick is Ruby `autoload`; port as: every expected class name resolves via `Newsmlg2.const_get` without explicit requires, and unknown names raise NameError. |
| `test_core.py` | `spec/newsmlg2/core_spec.rb` | error cases: non-NewsML root element; constructing with invalid input. Adapt the "non-Element to NewsItem" case to whatever our construction API raises (e.g. passing XML string to `.new` — document deviation). |
| `test_catalogitems.py` | `spec/newsmlg2/catalog_item_spec.rb` | parse inline catalog + LISTING_13; assert scheme/alias/definition details. |
| `test_conceptitems.py` | `spec/newsmlg2/concept_item_spec.rb` | 003, 005 (personDetails: born, affiliation, contactInfo email/phone/web/address), 006 (geoAreaDetails: position lat/long, polygon, founded, dissolved). |
| `test_events.py` | `spec/newsmlg2/events_spec.rb` | event ConceptItem; note python's `TestNewsMLG2EventFiles` is a copy-paste of the planning-item file test — port the *intent* (event file = LISTING_14 fragment) and record the deviation here. |
| `test_knowledgeitems.py` | `spec/newsmlg2/knowledge_item_spec.rb` | 002; conceptSet iteration, conceptId, name, related, `uri_to_qcode`. |
| `test_newsitems.py` | `spec/newsmlg2/news_item_spec.rb` | **largest**: 001, LISTING_1, LISTING_3; guid/standard/conformance/version defaults; catalog lookups (`get_scheme_for_alias`); `qcode_to_uri`/`uri_to_qcode`; itemClass/provider/versionCreated/pubStatus/service/edNote/signal/link; contentMeta deep assertions (contentCreated/Modified, located broader chain, creator orgDetails, subject multi-language names, genre, slugline, headline, description, creditline, keyword, language); rightsInfo; inlineXML contentSet; programmatic creation simple + complex with **exact XML output assertion**; missing-guid error; invalid-attribute error; array replace/delete. |
| `test_newsmessage.py` | `spec/newsmlg2/news_message_spec.rb` | 007; header fields; itemSet raw-XML behavior (assert our raw capture exposes the items' XML). |
| `test_packageitems.py` | `spec/newsmlg2/package_item_spec.rb` | LISTING_6; groupSet/group/itemRef attrs; contentMeta contributor details. |
| `test_planningitems.py` | `spec/newsmlg2/planning_item_spec.rb` | 004 (+LISTING_19 if fixture ported); newsCoverageSet entries; planning fields. |
| `test_roundtrip.py` | `spec/newsmlg2/roundtrip_spec.rb` | 008 fixture: parse → to_xml → **exact string equality** with our canonical output of the same pipeline (python asserts byte equality against lxml's own format; we assert equality against OUR canonical format — document this adaptation), plus semantic canon-equivalence against the original. |

## Ruby adaptation decisions (apply consistently)

- `GenericArray` → plain Ruby arrays; single-element delegation sugar
  (`contentmeta.subject.name`) becomes explicit `.first`
  (`contentmeta.subject.first.name`).
- `str(element) == "text"` → `element.text == "text"` (content-model attribute).
- `get_languages`/`get_for_language` → helper on i18n content collections
  (refinement or module included where needed) implemented in plan 07's
  `I18nContent` helper.
- Exception assertions: python `assertRaises(AttributeError)` → `expect { … }
  .to raise_error(Newsmlg2::…)`. Map each python error to a concrete
  `Newsmlg2::Error` subclass; missing guid at serialize time must raise like
  python's `assertRaises(Exception)` — pick `Newsmlg2::MissingGuidError`.
- Exact-XML-output tests: expected strings are re-generated from our canonical
  serializer format (pretty, single quotes/doubles as emitted, trailing
  newline) — they are fixtures of *our* output, checked in.
- **No doubles anywhere.** Real model instances only.

## Acceptance

- `bundle exec rspec` green across the full ported suite.
- A test-parity table appended below: python test function → rspec example
  full description, 35/35 accounted for (or split into more granular examples,
  which is fine — semantics, not count, must be complete).

## Parity table (completed)

| python test file | rspec file | examples |
|---|---|---|
| test_autoloader.py | spec/newsmlg2/roundtrip_core_spec.rb | 1 (class-resolution + NameError) |
| test_core.py | spec/newsmlg2/roundtrip_core_spec.rb + document_spec.rb | 2 |
| test_catalogitems.py | spec/newsmlg2/catalog_item_spec.rb | 2 |
| test_conceptitems.py | spec/newsmlg2/concept_item_spec.rb | 4 |
| test_events.py (string test) | spec/newsmlg2/concept_item_spec.rb (eventDetails/dates/confirmation) | covered |
| test_events.py (file test) | spec/newsmlg2/planning_item_spec.rb (duplicate of planning test in python) | covered |
| test_knowledgeitems.py | spec/newsmlg2/knowledge_item_spec.rb | 2 |
| test_newsitems.py | spec/newsmlg2/news_item_spec.rb | 13 |
| test_newsmessage.py | spec/newsmlg2/news_message_spec.rb + document_spec.rb | 2 |
| test_packageitems.py | spec/newsmlg2/package_item_spec.rb | 2 |
| test_planningitems.py | spec/newsmlg2/planning_item_spec.rb | 2 |
| test_roundtrip.py | spec/newsmlg2/roundtrip_core_spec.rb (+ all-fixtures loop) | 2 |

Additional adaptations beyond the plan:
- Byte-for-byte equality replaced by canonical-output byte equality +
  semantic (order/whitespace-insensitive) fidelity via canon +
  spec/support/xml_order_normalizer.rb; python's lxml output format
  (single-quoted declaration, always-declared nitf prefix) is not
  reproduced byte-identically.
- python's GenericArray single-element delegation reads as `.first`;
  get_languages/get_for_language are Newsmlg2::I18n.languages/for_language.
- The python test asserting `<located>` before `<digitalSourceType>` is
  XSD-incorrect; our canonical output follows the XSD sequence order.
- GenericArray constructor error and empty-Broader truthiness tests are
  python-implementation specifics without a Ruby equivalent (omitted).
- contentMeta/name (002 fixture quirk) is modelled on ContentMeta(ContentAcD)
  so the value round-trips instead of being dropped.
