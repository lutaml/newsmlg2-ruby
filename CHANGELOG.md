# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

- Architecture deepening: qcode ⇄ URI conversion moved from `Utils` onto
  `CatalogStore` (which owns the schemes); items expose `#catalog_holders`
  so `Document` no longer type-switches to find catalogs; the builder
  `build_*` factories and `ItemSet`'s carried-item mapping are generated
  from the `Configuration` registry instead of hand-mirroring it.

### Removed

- `Newsmlg2::Utils`: qcode conversion lives on `CatalogStore` and the
  `Newsmlg2.qcode_to_uri` / `Newsmlg2.uri_to_qcode` facade (both accept a
  document or a store).

### Performance

- `CatalogCache` derives its index from the bundled catalog directory
  and parses each bundled catalog once per process, shared across
  documents: parsing a document with a `catalogRef` drops from ~265ms to
  ~25ms warm (was re-reading and re-parsing the XML on every parse).
- The builder DSL is defined once per model class (`Builder::Node`
  proxies) instead of regenerated per wrapped node: node wraps drop from
  ~39µs to ~0.3µs.

### Fixed

- Builder DSL: assigning a non-coercible value to an attribute (most
  commonly a foreign object captured by `instance_eval` when an
  unqualified method call inside a block collides with an attribute name)
  now fails fast with an `ArgumentError` explaining the semantics,
  instead of corrupting the model graph and failing at serialization
  time.

### Added

- Builder DSL: `Time`, `Date`, `DateTime` and `Symbol` values are coerced
  into content-bearing types (ISO 8601, offset preserved).
- README documents the `instance_eval` gotcha and the precompute /
  explicit-receiver patterns.

## [0.1.1] - 2026-08-30

### Fixed

- `Newsmlg2.parse` now works on a fresh install with no XML adapter
  configured: when the configured adapter cannot be resolved, the
  stdlib REXML adapter is used instead of raising.
- Renamed `InlineData#encoding` to `#content_encoding` (wire name
  unchanged) to silence a lutaml-model override warning at load time.

## [0.1.0] - 2026-08-30

### Added

- Initial release: a lutaml-model-based Ruby object model for IPTC
  NewsML-G2 (NAR) targeting specification version 2.35 (power conformance).
- Typed parsing and serialization of all seven item types plus
  `newsMessage`, with per-document catalog stores and bundled IPTC
  catalogs (v32–v41) for offline qcode ⇄ URI resolution.
- Reflection-driven builder DSL (`Newsmlg2.build_news_item`, …) generated
  from the model metadata.
- Full port of the python-newsmlg2 test suite.
- Compliance fixtures: the 35 official IPTC example documents and the
  official IPTC XSD validation unit-test suite (161 files across schema
  versions 2.9–2.35).
