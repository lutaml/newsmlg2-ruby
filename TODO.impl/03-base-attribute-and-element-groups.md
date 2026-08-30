# 03 — Base attribute-group and element-group modules

Depends on: 02 (uses the confirmed mixin-composition pattern).

## Goal

Port python-newsmlg2's `attributegroups.py` and the reusable element-group
lists (module-level `*Group` lists scattered across modules) into Ruby mixin
modules under `Newsmlg2::Base::*`. These are the shared vocabulary every wire
class composes from — the analogue of chemicalml's `Base::*` files.

## References

- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/attributegroups.py` — source of truth, class by class
- XSD attribute groups: `/Users/mulgogi/src/external/newsml-g2/specification/individual/NewsML-G2_2.35-spec-Framework-Power.xsd` (17 groups; authoritative for attribute names/types)
- Pattern: `/Users/mulgogi/src/lutaml/chemicalml/lib/chemicalml/cml/base/common_children.rb`

## Deliverables

`lib/newsmlg2/base/<snake_name>.rb` per group + autoloads in the parent
namespace file. Two kinds of modules:

1. **Attribute groups** (from `attributegroups.py`, 17): each a module with
   `self.included(klass)` declaring its attributes (`attribute`) and
   `map_attribute` rules, appended to the includer's xml mapping per the
   pattern confirmed in plan 02:

   `CommonPowerAttributes` (`id`, `xml_lang`, `xml_base`, `xml_space`… — note
   xml:* handled via W3C namespace), `I18NAttributes` (`xml_lang`),
   `AuthorityAttributes`, `TargetResourceAttributes` (link),
   `DeprecatedLinkAttributes`, `QuantifyAttributes`, `TimeValidityAttributes`,
   `FlexAttributes` (`qcode`, `uri`, `type`), `RankingAttributes`,
   `PersistentEditAttributes`, `ArbitraryValueAttributes` (+content),
   `QualifyingAttributes` (`why`, `whyuri`), `NewsContentTypeAttributes`,
   `MediaContentCharacteristics1`, `NewsContentCharacteristics`,
   `ConfirmationStatusAttributes`, `RecurrenceRuleAttributes`.

2. **Element-group modules** (from the `*Group` list concatenations): each
   declares the group's child-element attributes and `map_element` rules:

   - `Base::ItemManagementGroup` (`itemmanagement.py`: itemClass, provider,
     versionCreated, firstCreated, embargoed, pubStatus, role, fileName,
     generator, profile, service, title, edNote, memberOf, instanceOf, signal,
     altRep, deliverableOf, hash, expires, origRep, incomingFeedId,
     metadataCreator + links/extension points)
   - `Base::DescriptiveMetadataGroup` (`contentmeta.py`: language, genre,
     keyword, subject, slugline, headline, dateline, by, creditline,
     description)
   - `Base::AdministrativeMetadataGroup` (`contentmeta.py`)
   - `Base::ConceptDefinitionGroup`, `Base::ConceptRelationshipsGroup`
     (`concepts.py` / `conceptrelationships.py`)
   - `Base::RightsGroup`, any other `*Group` lists found by grepping
     `python-newsmlg2/NewsMLG2/*.py` for `Group = [`.

## Steps

1. Grep the python sources for every `attributes = {` class in
   `attributegroups.py` and every `Group = [` list; build the complete
   inventory first (append it below).
2. Implement modules using only the confirmed composition pattern; wire every
   autoload in `lib/newsmlg2/base.rb` (create the namespace file — never
   `require_relative`).
3. Element groups reference child classes that don't exist yet (plans 04+);
   use lutaml-model's lazy class resolution (symbol/class-name references) or
   define the groups with forward references per lutaml-model's API — confirm
   mechanism in this plan's first module and reuse.
4. Unit specs `spec/newsmlg2/base/*_spec.rb`: for each module, build an
   anonymous `Lutaml::Model::Serializable` including it (+ minimal xml root),
   round-trip a representative XML fragment; assert wire names (camelCase)
   map to snake_case Ruby attributes.

## Acceptance

- Every group module has a spec proving attribute/element mapping round-trips.
- `rspec spec/newsmlg2/base` green; rubocop clean (metrics exclusions apply).

## Inventory (fill during implementation)

(python class → ruby module → attributes count)


## Status: COMPLETE

Implemented in `lib/newsmlg2/base/`, `lib/newsmlg2/types/`, `lib/newsmlg2/items/`.
The per-class inventories are embodied in the code: every python class maps to a Ruby
class named after its XSD type (element names declared once at usage sites). Deviations
from python (all XSD-driven or cycle-driven) are documented in the source comments:
FlexOrganisationPropType replaced by the composed Types::Affiliation; the two identical
python affiliation classes collapsed into one; ItemSet uses raw xs:any capture with a
typed #items accessor; Assert captures xs:any content raw; contentMeta carries a
modelled `names` element for the fixture quirk.
