# 04 — Simple and complex shared types

Depends on: 03.

## Goal

Port python-newsmlg2's `simpletypes.py` and `complextypes.py` (plus any small
value classes referenced by them) into `Newsmlg2::Types::*`
(`Lutaml::Model::Serializable` subclasses or custom `Lutaml::Model::Type`s).

## References

- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/simpletypes.py`
- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/complextypes.py`
- XSD: Framework-Power.xsd type definitions with the same names.

## Deliverables

`lib/newsmlg2/types/<snake>.rb`, autoloaded from `lib/newsmlg2/types.rb`.

**Simple types** — keep as plain strings exactly like python-newsmlg2 (no
runtime validation; the official XSD suite in plan 12 is the validator):
`DateOptTimeType`, `TruncatedDateTimeType`, `UnionDateTimeType`,
`QCodeType`, `IRIType`, `IRIorQCodeType`, `GUIDType`, `NarrowedQCodeType`,
`NonRationalNumberType`, `RatioType`, `StringPlusLanguageType`, etc.
Represent each as a named custom type or simply `:string` attributes whose
names document intent — follow whatever is least machinery; do not invent
validation python doesn't have.

**Complex types** — real Serializable classes with `map_content` where the
python class reads `xmlelement.text`:

- `DateTimePropType` (content = ISO date-time string) — used by
  versionCreated, contentCreated, scheduled etc.
- `IntlStringType` (content + optional `dir`), `TruncatedDateTimePropType`,
  `DateOptTimePropType`
- `Preamble` (`PreambleType`, content)
- `Name` (`ConceptNameType`: content + `why`/`whyuri` via QualifyingAttributes)
- `Note`, `Definition`, `Usage`, `Status`, `MimeType`, `Relation` etc. — port
  every class in `complextypes.py`; inventory them all below before coding.
- `Label1Type`, `BlockType`, `Span`, `Ruby`, `A` come from `labeltypes.py`
  (mixed content — plan 07) not here.

Naming: Ruby class keeps the XSD name (`DateTimePropType`), wire name is the
element name at the usage site (`map_element "versionCreated", to: :…`).

## Steps

1. Inventory every class in the two python modules; append the table below.
2. Implement + `spec/newsmlg2/types/*_spec.rb` per class: construct from XML
   fragment, assert `.text`/attributes, round-trip.
3. Text access: content models expose the text via the mapped content
   attribute (e.g. `version_created.text`) — assert that in specs; this is the
   ported equivalent of python's `str(itemmeta.versioncreated) == '…'`.

## Acceptance

- All types implemented with round-trip specs; `rspec spec/newsmlg2/types` green.

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
