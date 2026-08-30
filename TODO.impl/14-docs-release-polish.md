# 14 — Docs, remaining workflows, release polish

Depends on: all previous plans complete and green.

## Goal

Finish the chemicalml workflow parity (docs/links/links/opal/performance
workflows), documentation, and changelog. Ready the gem for a first release
(**releases themselves are user-dispatched only**).

## Deliverables

1. `README.adoc` (or `.md` — match chemicalml's README format; check
   `/Users/mulgogi/src/lutaml/chemicalml/README.*`): what/why, install,
   quickstart (parse a fixture), builder DSL example from plan 13, catalog
   utilities, test-tier description, reference-implementation credits
   (python-newsmlg2, IPTC newsml-g2 spec/examples — CC-BY 4.0 attribution for
   vendored IPTC material; add `spec/fixtures/iptc/README.md` stating source
   repo + commit hash and license).
2. `docs/` minimal Jekyll site (index + usage pages) + `.github/workflows/docs.yml`
   and `links.yml` **copied verbatim from chemicalml** (paths within `docs/`
   may need name adjustments only).
3. Opal parity: `opal` group in Gemfile (`bundle config set with opal`),
   `lib/tasks/opal.rake` providing `rake spec:opal` compiling and running a
   smoke spec (parse + serialize a minimal newsItem under Opal), and
   `.github/workflows/opal.yml` copied from chemicalml. If a dependency
   (nokogiri adapter) blocks Opal, document the constraint in the workflow
   comment and keep the smoke spec to the ox/oga adapter path if viable —
   do not fake green.
4. Performance parity: `lib/tasks/performance.rake` with
   `rake performance:compare` (serialize/parse timings over the 35 IPTC
   examples vs a stored baseline JSON, skipped with a clear message when no
   baseline exists) + `.github/workflows/performance.yml` copied from
   chemicalml.
5. `CHANGELOG.md` — Keep-a-Changelog skeleton with an initial "Unreleased"
   section describing the port (feature list), following chemicalml's format.
6. Final sweep: `bundle exec rspec` (all tiers) green, `bundle exec rubocop`
   clean, `gem build` output sanity (contains lib + catalogs, no spec files).

## Acceptance

- All six chemicalml workflows exist and their steps would pass in CI (verify
  rake task names referenced by each workflow actually exist).
- README examples are runnable copy-paste (extract-codable: verify by running
  them in a scratch spec).
- CHANGELOG present; version file still `0.1.0` (bumping is the user's call at
  release time).


## Status: COMPLETE

README.adoc, CHANGELOG.md, docs/ (Jekyll site + Gemfile + _config.yml so
docs.yml/links.yml actually build), performance.yml + a real
lib/tasks/performance.rake (baseline/compare over the IPTC examples),
spec/fixtures/iptc/README.md attribution.

opal.yml is not adopted: opal support is explicitly not wanted for this
gem (owner decision, 2026-08-30).
