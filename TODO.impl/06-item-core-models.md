# 06 — Core item models: AnyItem, ItemMeta, ids, partMeta

Depends on: 03, 04 (Base groups + types).

## Goal

Port the item-core layer of python-newsmlg2: `anyitem.py`, `itemmanagement.py`,
`ids.py`, `partmeta.py` — everything under `itemMeta` plus the abstract item
base all seven item types inherit from.

## References

- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/anyitem.py`
  (AnyItem: `itemmeta` element, default attributes standard/standardversion/
  conformance/guid/version, `xsAny` = xmldsig namespace)
- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/itemmanagement.py`
  (~30 classes: ItemClass, Provider, Party(→concepts), VersionCreated,
  FirstCreated, Embargoed, PubStatus, Role, FileName, Generator, Profile,
  Service, Title, EdNote, MemberOf, InstanceOf, Signal, AltRep, DeliverableOf,
  Hash, Expires, OrigRep, IncomingFeedId, MetadataCreator, Link…)
- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/ids.py` (AltId, Hash)
- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/partmeta.py`
  (PartMeta, TimeDelim, RegionDelim + admin/descriptive groups)
- XSD: Framework-Power.xsd `ItemMetadataType`, `partMetaPropType`.

## Deliverables

- `lib/newsmlg2/any_item.rb` — abstract base Serializable including
  `Base::CommonPowerAttributes` + `Base::ItemManagementGroup` container
  (`itemMeta` child). Declares required attributes with defaults:
  `standard "NewsML-G2"`, `standardversion "2.35"`, `conformance "power"`,
  `version "1"`, `guid` (no default; required at item level), rendered per the
  plan-02 defaults idiom. `xsAny` (xmldsig + `##other` extension) via the
  confirmed raw-capture idiom.
- `lib/newsmlg2/item_meta.rb` + `lib/newsmlg2/item_management/*.rb` — one class
  per python class; `ItemMeta` includes `Base::ItemManagementGroup`.
- `lib/newsmlg2/ids.rb` (AltId, Hash), `lib/newsmlg2/part_meta.rb` (+ TimeDelim,
  RegionDelim).
- Child classes referenced but belonging to later plans (Party, ConceptId,
  Link…) resolved when those land; use the forward-reference mechanism chosen
  in plan 03.

## Steps

1. Inventory python classes per module (append table below).
2. Implement in dependency order: ids → itemmanagement children → itemMeta →
   anyitem → partmeta.
3. Per class: unit spec with a representative XML fragment round-trip (parse →
   assert typed access → serialize → canon-equivalent).
4. Element ordering: NewsML-G2 requires ordered child elements (XSD sequence).
   If lutaml-model serializes by mapping declaration order, declare `map_element`s
   in schema order; verify against the XSD sequence in Framework-Power.xsd.
   Check `xml_orderable.rb` / element_sequence support if ordering matters for
   round-trip byte equality.

## Acceptance

- `rspec spec/newsmlg2` green including new `any_item_spec`, `item_meta_spec`,
  `part_meta_spec`.
- A hand-built `ItemMeta` with itemClass/provider/versionCreated serializes to
  schema-ordered XML that the 2.35 All-Power XSD validates (spot-check with
  `Lutaml::Xml::XsdValidator` — full validation suite is plan 12).

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
