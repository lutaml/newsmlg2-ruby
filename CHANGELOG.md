# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

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
