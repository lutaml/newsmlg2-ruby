# CONTEXT.md — newsmlg2 domain glossary

Domain vocabulary for NewsML-G2 (NAR 2.35, power conformance) as modeled
by this gem. Architecture reviews and ADRs use these terms.

## Items and messages

- **Item** — a NewsML-G2 document root of one of seven types (newsItem,
  packageItem, conceptItem, knowledgeItem, catalogItem, planningItem;
  modeled by `Newsmlg2::AnyItem` subclasses). Carries `itemMeta` and type
  metadata; requires a `guid` before serialization.
- **NewsMessage** — an envelope exchanging items through an `itemSet`,
  with exchange metadata on its `header`.
- **Registry** — `Newsmlg2::Configuration`: the single source of truth
  mapping element id (e.g. `newsItem`) to model class. Root dispatch,
  builder factories and itemSet mapping all derive from it.

## The catalog system

- **Catalog** — a set of scheme declarations, inline (`<catalog>`) or
  referenced (`<catalogRef href=…>`, resolved offline from the bundled
  IPTC catalogs).
- **Scheme** — one alias-to-URI mapping inside a catalog
  (`alias="ninat"`, `uri="http://cv.iptc.org/newscodes/ninature/"`).
- **QCode** — a compressed concept reference `alias:code` (e.g.
  `ninat:text`); expanded to a full concept URI through the document's
  schemes (`CatalogStore#qcode_to_uri`).
- **Catalog store** — `Newsmlg2::CatalogStore`: the per-document set of
  catalogs; owns scheme lookup and qcode ⇄ URI conversion. The whole
  qcode system is testable through this one interface.
- **Catalog holder** — an element that carries catalogs/catalogRefs: an
  item holds them inline; a newsMessage holds them on its header.
  `#catalog_holders` is the seam `Document` uses to build the store
  without knowing concrete item types.

## Building

- **Builder** — reflection-driven DSL generating node methods from model
  metadata; `build_*` factories derive from the registry. Blocks run
  under `instance_eval` (see README gotcha).
