# Vendored IPTC material

Everything under `spec/fixtures/iptc/` is vendored verbatim from the
official IPTC repository https://github.com/iptc/newsml-g2 — schemata,
example documents and the official unit-test suite — and from
https://github.com/iptc/python-newsmlg2 (its test fixtures).

- Source: iptc/newsml-g2, branch `main` (2.35 release files, retrieved
  2026-08-30); iptc/python-newsmlg2 `tests/test_files/`.
- License: NewsML-G2 schemas and documentation are published under
  Creative Commons Attribution 4.0; the test runner and python library are
  MIT licensed. Neither license restricts redistribution.
- The file × schema validation matrix in `test_matrix.json` is extracted
  from `tests/runtests.py` of iptc/newsml-g2.

Do not modify these files; refresh them by re-copying from the sources.
