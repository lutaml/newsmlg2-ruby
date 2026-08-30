# 11 — Adopt official IPTC examples as compliance fixtures

Depends on: 09 (can run in parallel with 10; both need the full model layer).

## Goal

Vendor the official IPTC NewsML-G2 example documents and turn every one of
them into a compliance spec: parse → typed assertions → semantic round-trip.

## References

- `/Users/mulgogi/src/external/newsml-g2/examples/` — 31 `LISTING_*.xml` files
  (specification listings) + `Receiver View.xml`, `ap_metadata_example.xml`,
  `facet-example{,-2,-3}.xml` (35 total)
- `/Users/mulgogi/src/external/newsml-g2/releases/2.35/examples/` — same set,
  2.35 snapshot (vendor this copy)
- python-newsmlg2 also carries the listings in its own `examples/` (29 files)
  — official repo is the authority.

## Deliverables

- `spec/fixtures/iptc/examples/` — the 35 XML files copied verbatim.
- `spec/compliance/examples_spec.rb` — generated per file:
  1. `Newsmlg2.parse_fixture` parses without error;
  2. root item class is the expected one (hard-coded expectation map below);
  3. "no silently dropped children": re-serialize and canon-compare
     (`be_xml_equivalent_to`, wrapping in `<r>…</r>` as chemicalml does) —
     this catches any modeled-away element;
  4. 2–5 typed spot assertions per interesting file (headline, guid, qcode of
     itemClass, group counts…) taken from reading each listing.
- A `PENDING_SEMANTIC` list (chemicalml pattern) for files that don't round-trip
  yet, each entry with a one-line reason. **The list must be empty at the end
  of this plan** — anything pending means the model layer has a gap; fix the
  model, not the test.

## Root-class expectation map (verify against file names while vendoring)

LISTING_1,2,3,3A,4,5 → NewsItem; 6–9 → PackageItem; 10,11,14 → ConceptItem;
12,15 → KnowledgeItem; 13 → CatalogItem; 16 → NewsItem; 17–20 → PlanningItem;
21,22 → NewsItem (SportsML/NITF inline); 23 → PackageItem; 24 → NewsMessage;
25–29 → NewsItem; plus the 4 non-listing files (inspect each).

## Steps

1. Vendor files (script the copy; record file count = 35).
2. Write the spec skeleton with expectation map; run; triage failures into
   model bugs vs. parser gaps; fix models until green.
3. Add spot assertions per file (read each listing's notable features —
   e.g. LISTING_5 partMeta/timeDelim, LISTING_7 hierarchical group structure,
   LISTING_12 access-code knowledge, LISTING_29 hopHistory).

## Acceptance

- All 35 examples parse, classify correctly, round-trip semantically;
  `PENDING_SEMANTIC` empty; suite green.

## Notes

- `LISTING_21/22/23` embed SportsML-G2/NITF foreign namespaces — these
  exercise the raw `map_all` capture path hardest; if canon flags prefix
  re-declaration differences, prefer fixing namespace emission on our side
  over weakening the matcher.


## Status: COMPLETE

Implemented in `lib/newsmlg2/base/`, `lib/newsmlg2/types/`, `lib/newsmlg2/items/`.
The per-class inventories are embodied in the code: every python class maps to a Ruby
class named after its XSD type (element names declared once at usage sites). Deviations
from python (all XSD-driven or cycle-driven) are documented in the source comments:
FlexOrganisationPropType replaced by the composed Types::Affiliation; the two identical
python affiliation classes collapsed into one; ItemSet uses raw xs:any capture with a
typed #items accessor; Assert captures xs:any content raw; contentMeta carries a
modelled `names` element for the fixture quirk.
