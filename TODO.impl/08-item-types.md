# 08 — The seven concrete item types + NewsMessage

Depends on: 05, 06, 07.

## Goal

Port the top-level document items: `newsitem.py`, `conceptitem.py`,
`knowledgeitem.py`, `packageitem.py`, `planningitem.py`, `newsmessage.py`,
`catalogitem.py` (the class; its subsystem landed in plan 05).

## References

- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/newsitem.py` — NewsItem
  (contentMeta, partMeta+, assert+, contentSet), ContentSet (choice:
  InlineXML | RemoteContent+), InlineXML (raw foreign-namespace content via
  map_all idiom), RemoteContent (href, contenttype, size, rendition,
  hash, datacontent…)
- `conceptitem.py` — ConceptItem (concept/conceptId + meta)
- `knowledgeitem.py` — KnowledgeItem, ConceptSet, SchemeMeta
- `packageitem.py` — PackageItem, GroupSet (StrdxGroupSetType hierarchy/ALT/SEQ
  modes), Group (id, role, rank), ItemRef (residref, contenttype, size,
  version, format, generation), ContentItem within packages
- `planningitem.py` — PlanningItem, NewsCoverageSet, NewsCoverage (with
  scope/aspect), Planning (g2ContentType, itemClass, assignedTo, scheduled,
  urgency, services, edNote…), Delivery
- `newsmessage.py` — NewsMessage (header + itemSet), Header (sent, catalogRef,
  sender, transmitId, priority, origin, destination, channel, timestamp,
  signal), ItemSet (holds arbitrary items — xs:any-style raw capture in
  python; we model what's parseable + raw fallback per plan-02 idiom)
- `catalogitem.py` — CatalogItem (catalog child from plan 05)
- XSD entry schemas: `NewsML-G2_2.35-spec-{NewsItem,NewsMessage,PackageItem,
  KnowledgeItem,PlanningItem,CatalogItem,ConceptItem}-Power.xsd`.

## Deliverables

- `lib/newsmlg2/news_item.rb`, `concept_item.rb`, `knowledge_item.rb`,
  `package_item.rb`, `planning_item.rb`, `catalog_item.rb`, `news_message.rb`
  + their child classes (`content_set.rb`, `inline_xml.rb`, `remote_content.rb`,
  `group_set.rb`, `group.rb`, `item_ref.rb`, `news_coverage_set.rb`,
  `news_coverage.rb`, `planning.rb`, `delivery.rb`, `news_message/header.rb`
  or flat `news_message_header.rb`, etc.).
- Each root class declares `root "newsItem"` etc. with `NarNamespace`, and a
  class-level `xml_root_name` used by the document dispatcher (plan 09).

## Steps

1. Inventory the six modules' classes (append below).
2. Implement leaf-first (ContentSet parts, Group/ItemRef, NewsCoverage/Planning/
   Delivery, NewsMessage header parts) then the item roots.
3. Unit specs: minimal programmatic construction per item type mirroring
   python's `test_create_simple_newsitem_in_code` style (guid + lang only for
   NewsItem), plus parse specs over the 13 python fixtures already relevant
   here (`spec/fixtures/python/test_files/00*.xml` — copy them in now, see
   plan 10 for the full set).

## Acceptance

- All seven item types + NewsMessage parse their python-test fixtures and
  round-trip them with canon semantic equivalence.
- Programmatic NewsItem(guid, xml_lang) serializes to XML matching the
  canonical form recorded in plan 02.

## Inventory (fill during implementation)


## Status: COMPLETE

Implemented in `lib/newsmlg2/base/`, `lib/newsmlg2/types/`, `lib/newsmlg2/items/`.
The per-class inventories are embodied in the code: every python class maps to a Ruby
class named after its XSD type (element names declared once at usage sites). Deviations
from python (all XSD-driven or cycle-driven) are documented in the source comments:
FlexOrganisationPropType replaced by the composed Types::Affiliation; the two identical
python affiliation classes collapsed into one; ItemSet uses raw xs:any capture with a
typed #items accessor; Assert captures xs:any content raw; contentMeta carries a
modelled `names` element for the fixture quirk.
