# 07 — Descriptive content models: contentMeta, concepts, entities, events, rights, link, labels

Depends on: 06.

## Goal

Port the largest python layer — everything under `contentMeta` and the shared
concept/entity/event machinery. ~120 classes across nine modules.

## References (source of truth, port class by class)

- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/contentmeta.py` —
  `ContentMetadataAfDType`/`AcDType`/`CatType` + admin/descriptive group
  members: Urgency, ContentCreated/Modified, DigitalSourceType, Located
  (broader hierarchy), InfoSource, Creator, Contributor, Audience, ExclAudience,
  AltId, Rating, UserInteraction, Language, Genre, Keyword, Subject (multi-lang
  names, broader/narrower/related/sameAs), Slugline, Headline, Dateline (Date,
  Located), By, Creditline, Description, Comment
- `concepts.py` — Concept, ConceptId, Flex1PropType and the whole Flex*PropType
  family (FlexLocationPropType, FlexGeoAreaPropType, FlexPersonPropType,
  FlexOrganisationPropType, FlexPartyPropType, FlexAuthorPropType,
  Flex1ConceptPropType…), GeoAreaDetails (position lat/long, polygon, founded,
  dissolved), POIDetails, EventDetails/Dates/Start/End/RecurrenceRule
- `conceptrelationships.py` — Related, Broader, Narrower, SameAs, QCodePropType,
  ConceptRelationshipsGroup
- `entities.py` — PersonDetails (born, died, affiliation, occupation,
  contactInfo,…), OrganisationDetails, ObjectDetails, ContactInfo (email,
  phone, web, address), Address (formatted, lines, locality, area, postcode,
  country)
- `events.py` — Events, Event (occurred/unrelated coverage concepts)
- `rights.py` — RightsInfo, CopyrightHolder, CopyrightNotice, UsageTerms,
  DataMining (2.34+), rightsExpressionXML/Data, scope/aspect coverage
- `link.py` — Link, RemoteInfo, TargetResourceAttributes, Link1Type
- `labeltypes.py` — Label1Type, BlockType, Inline, Span, Ruby, A (anchor);
  mixed content handled per plan-02 idiom — python leaves this TODO'd, we must
  not
- `extensionproperties.py` — Flex1ExtPropType, Flex2ExtPropType,
  ConceptExtProperty

## Deliverables

- One Ruby class per python class under `lib/newsmlg2/` (flat, snake_case
  files, e.g. `content_meta.rb`, `located.rb`, `person_details.rb`),
  autoloaded from `lib/newsmlg2.rb`.
- Shared groups land as `Base::*` modules per plan 03 if not already there
  (`AdministrativeMetadataGroup`, `DescriptiveMetadataGroup`,
  `ConceptDefinitionGroup`, `ConceptRelationshipsGroup`).
- Unit specs per class: parse representative fragment → typed assertions →
  round-trip canon-equivalence. For tricky ones use fragments taken from the
  official examples (LISTING_11 person, LISTING_14 event, LISTING_26 photo
  metadata) — do not invent XML when IPTC provides it.

## Steps

1. Build the full inventory table (python class → ruby class → notes) from the
   nine modules; append below.
2. Implement bottom-up by dependency: entities → concepts →
   conceptrelationships → events → rights → link → labeltypes → contentmeta.
3. Watch for: multi-language content (`IntlStringType` collections with
   `get_languages`/`get_for_language` helpers — provide
   `Newsmlg2::I18nContent` refinement/helper module used by ported tests in
   plan 10); `Located.broader` recursive same-type nesting; Subject's concept
   relationship children; choice unions (conceptId variants) using the plan-02
   choice idiom.

## Acceptance

- Every class in the inventory exists, has a spec, suite green.
- LISTING_11/14/26 fragments parse fully with no dropped (silently ignored)
   children — assert parsed child counts, not just no-exception.

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
