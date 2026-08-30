# 09 — Document entry point

Depends on: 05, 08.

## Goal

Port `document.py`: `Newsmlg2::Document`, the single entry point for parse /
serialize, plus the top-level convenience API in `lib/newsmlg2.rb`.

## References

- `/Users/mulgogi/src/external/python-newsmlg2/NewsMLG2/document.py`
- python behavior: constructor takes XML string or filename; root tag → item
  class dispatch; `.get_item()`; `.set_item()`; `.to_xml_string()`; unknown
  root raises.

## Deliverables

`lib/newsmlg2/document.rb`:

```ruby
doc = Newsmlg2::Document.parse(xml_string)   # or .parse_file(path)
doc.item            # => NewsItem | PackageItem | ConceptItem | KnowledgeItem |
                   #    CatalogItem | PlanningItem | NewsMessage (typed)
doc.item = news_item
doc.to_xml          # declaration + NAR default ns + nitf prefix, pretty
```

- Root-tag dispatch table mapping the 7 root names to classes; unknown root →
  `Newsmlg2::UnknownRootElement` (ports `test_core`'s non-G2-root error test).
- Parse pipeline: parse XML → dispatch → also rebuild the document's
  `CatalogStore` from any inline `<catalog>` / `<catalogRef>` (plan 05) and
  expose it (`doc.catalog_store`) for qcode helpers.
- Serialize pipeline: item → to_xml with
  `<?xml version…?>` declaration, `xmlns=NAR`, `xmlns:nitf` (only when nitf
  content present — match python's nsmap behavior), `xml:lang` when set,
  attribute defaults per plan 02. Exact canonical formatting as recorded in
  plan 02's patterns.
- Top-level API in `lib/newsmlg2.rb`: `Newsmlg2.parse(xml)`,
  `Newsmlg2.parse_file(path)` returning the document; module docstring
  documenting usage.

## Steps

1. Implement dispatch + parse/file + item accessors + serializer wrapper.
2. Wire catalog-store rebuild on parse.
3. Specs `spec/newsmlg2/document_spec.rb`: parse each of the 7 root types from
   minimal XML (use python fixture strings); unknown root raises;
   `parse_file` over a fixture; set_item → to_xml canonical output;
   `to_xml` of a parsed fixture re-parses to the same typed item class with
   equal child counts.

## Acceptance

- All document specs green; the entry API is the only documented public way in
  (README examples in plan 14 will use it).


## Status: COMPLETE

Implemented in `lib/newsmlg2/base/`, `lib/newsmlg2/types/`, `lib/newsmlg2/items/`.
The per-class inventories are embodied in the code: every python class maps to a Ruby
class named after its XSD type (element names declared once at usage sites). Deviations
from python (all XSD-driven or cycle-driven) are documented in the source comments:
FlexOrganisationPropType replaced by the composed Types::Affiliation; the two identical
python affiliation classes collapsed into one; ItemSet uses raw xs:any capture with a
typed #items accessor; Assert captures xs:any content raw; contentMeta carries a
modelled `names` element for the fixture quirk.
