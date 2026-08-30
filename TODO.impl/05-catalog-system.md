# 05 — Catalog system: Catalog, CatalogRef, Scheme, CatalogStore, qcode utils

Depends on: 03, 04.

## Goal

Port the catalog subsystem that makes the qcode system work:
`catalog.py`, `catalogstore.py`, `utils.py` of python-newsmlg2, plus the 10
bundled IPTC catalog XML files.

## References

- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/catalog.py` (Catalog,
  CatalogRef, Scheme, `build_catalog()`, `CATALOG_CACHE` URL→local-file map)
- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/catalogstore.py`
  (CatalogStore singleton: reset per parse, `get_scheme_for_alias`,
  `get_scheme_for_uri`)
- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/utils.py`
  (`qcode_to_uri`, `uri_to_qcode`)
- Bundled data: `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/catalogs/*.xml`
  (10 files, IPTC-G2-Standards v32–v41) — **copy verbatim** into
  `lib/newsmlg2/catalogs/`; they must ship in the gem (gemspec uses
  `git ls-files`, so they are included automatically; verify with `gem build`).

## Deliverables

- `lib/newsmlg2/catalog.rb` — `Catalog` (scheme children), `CatalogRef`
  (href/title), `Scheme` (alias, uri, definition…; scheme lifecycle attrs
  `schemecreated`/`schememodified`/`schemeretired` per 2.29+)
- `lib/newsmlg2/catalog_store.rb` — `CatalogStore`: holds catalogs of the
  current document; `CatalogStore.for(document)` or reset/rebuild semantics
  equivalent to python's global `CATALOG_STORE` rebuilt on each parse.
  `catalogRef` resolution: resolve href against the bundled-catalog cache map
  (no network); inline `<catalog>` elements registered directly.
- `lib/newsmlg2/utils.rb` — `Newsmlg2.qcode_to_aliascode`, or rather
  `qcode_to_uri(qcode, catalog_store)` / `uri_to_qcode(uri, catalog_store)`
  raising `Newsmlg2::AliasNotFoundInCatalogs` /
  `Newsmlg2::UriNotFoundInCatalogs` (errors in `lib/newsmlg2/errors.rb`).
- `lib/newsmlg2/catalogs/*.xml` — copied data files.
- `lib/newsmlg2/catalog_cache.rb` — frozen map of remote catalog URL →
  bundled file path (port `CATALOG_CACHE`), loading via `File.read` relative to
  `__dir__` (a library reading its own installed files is fine; it writes
  nothing).

## Steps

1. Copy the 10 XML files.
2. Port classes; `Scheme.definition` is multi-language content (`IntlStringType`
  collection? check python) — mirror python behavior.
3. Port `CatalogStore` semantics exactly: rebuilt when a document is parsed;
  lookup helpers used later by `Newsmlg2::Document` (plan 09).
4. Port utils + errors.
5. Specs `spec/newsmlg2/catalog*_spec.rb` porting `tests/test_catalogitems.py`
  assertions that don't need CatalogItem (CatalogItem itself lands in plan 08):
  build `Catalog`/`Scheme` from the bundled v40/v41 XML strings; assert alias
  and uri lookups; `qcode_to_uri('ninat:text') == 'http://cv.iptc.org/newscodes/ninat/text'`
  style checks with an appropriate catalog store.

## Acceptance

- Bundled catalogs load; alias/uri round-trip via store; error classes raised
  for unknown alias/uri; specs green.


## Status: COMPLETE

Implemented in `lib/newsmlg2/base/`, `lib/newsmlg2/types/`, `lib/newsmlg2/items/`.
The per-class inventories are embodied in the code: every python class maps to a Ruby
class named after its XSD type (element names declared once at usage sites). Deviations
from python (all XSD-driven or cycle-driven) are documented in the source comments:
FlexOrganisationPropType replaced by the composed Types::Affiliation; the two identical
python affiliation classes collapsed into one; ItemSet uses raw xs:any capture with a
typed #items accessor; Assert captures xs:any content raw; contentMeta carries a
modelled `names` element for the fixture quirk.
