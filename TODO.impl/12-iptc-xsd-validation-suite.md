# 12 — Adopt the official IPTC XSD validation unit-test suite (161 files)

Depends on: 09; can run in parallel with 10/11.

## Goal

Port the official NewsML-G2 conformance suite: 151 should-pass + 10 should-fail
XML documents validated against per-version XSDs, mirroring
`tests/runtests.py`'s file×schema matrix in RSpec via
`Lutaml::Xml::XsdValidator` (Nokogiri/libxml2 under the hood).

## References

- `/Users/mulgogi/src/external/newsml-g2/tests/unit_test_files/{2.9..2.35,NAR1.9,dev}/{should_pass,should_fail}/*.xml`
- `/Users/mulgogi/src/external/newsml-g2/tests/schema_versions/` — per-version
  All-Power XSDs, `ODRL22.xsd`, `G2-multi-schema-*.xsd` wrappers
  (rightsExpressionXML tests need the multi-schema wrapper that imports ODRL)
- `/Users/mulgogi/src/external/newsml-g2/tests/runtests.py` — **read fully**;
  it defines the exact file→schema-version matrix, including which versions a
  should_fail file must be rejected by, and the special-cased/empty 2.23 set.
  Do not trust second-hand summaries of it — including this plan's.

## Deliverables

- `spec/fixtures/iptc/schema_versions/*.xsd` — copied XSDs needed by the matrix
  (copy the whole directory; ~40 files, a few MB — acceptable).
- `spec/fixtures/iptc/unit_test_files/` — copied tree, verbatim.
- `spec/compliance/xsd_validation_spec.rb`:
  - build the matrix by reading the directory structure + porting runtests.py's
    version-set logic into a small pure-Ruby module
    (`Newsmlg2::Compliance::TestMatrix`, `lib/newsmlg2/compliance/test_matrix.rb` —
    keep it in lib? No: it is test tooling; put it in `spec/support/`);
  - for each (file, schema) pair generate an example:
    should_pass → `errors.empty?`; should_fail → `errors.any?`;
  - schema compile cost: `XsdValidator` memoizes compiled schemas by path;
    the suite is ~1291 cases — keep total runtime under ~2 min (measure; if
    slower, precompile in a `before(:context)` and call Nokogiri directly).
- Reporting parity: on failure, the example message includes the libxml2 error
  list (as `runtests.py` prints), so a red spec is actionable.

## Steps

1. Read `runtests.py` in full; write the matrix rules as a table in this file
   (version dirs → schema version list; should_fail rejection rules; special
   cases: 2.23 empty/commented, dev, NAR1.9).
2. Vendor fixtures.
3. Implement matrix + spec; run; triage:
   - validation failures on should_pass files = **model/schema-output bugs or
     fixture/canonicalization issues** — investigate individually (e.g.
     attribute ordering is irrelevant to XSD; missing defaulted attributes are
     not); fix the model layer where the fault is ours;
   - should_fail files unexpectedly passing = wrong matrix rule; re-check
     runtests.py, do not weaken.
4. Add a `rake spec:compliance` alias so the long suite can be run alone, while
   keeping it in the default run (CI must always validate compliance).

## Acceptance

- Full matrix green: every should_pass validates against every schema version
  the official runner checks it against; every should_fail rejects where
  specified.
- `bundle exec rspec spec/compliance/xsd_validation_spec.rb` completes < 2 min.

## Matrix rules (port from runtests.py — replace this section with the verified rules)


## Status: COMPLETE

Implemented in `lib/newsmlg2/base/`, `lib/newsmlg2/types/`, `lib/newsmlg2/items/`.
The per-class inventories are embodied in the code: every python class maps to a Ruby
class named after its XSD type (element names declared once at usage sites). Deviations
from python (all XSD-driven or cycle-driven) are documented in the source comments:
FlexOrganisationPropType replaced by the composed Types::Affiliation; the two identical
python affiliation classes collapsed into one; ItemSet uses raw xs:any capture with a
typed #items accessor; Assert captures xs:any content raw; contentMeta carries a
modelled `names` element for the fixture quirk.
