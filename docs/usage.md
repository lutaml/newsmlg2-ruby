# Usage

## Parsing

```ruby
require "newsmlg2"

doc = Newsmlg2.parse_file("newsitem.xml")
doc.item                       # typed item, e.g. Newsmlg2::NewsItem
doc.item.item_meta.item_class.qcode
```

## Catalogs and qcodes

```ruby
doc.catalog_store.get_scheme_for_alias("ninat").uri
Newsmlg2.qcode_to_uri("ninat:text", doc)
Newsmlg2.uri_to_qcode("http://cv.iptc.org/newscodes/ninature/text", doc)
```

## Builder DSL

```ruby
Newsmlg2.build_news_item(guid: "...", lang: "en-GB") do |item|
  item.item_meta do |meta|
    meta.item_class qcode: "ninat:text"
    meta.version_created "2026-08-30T12:00:00+00:00"
  end
end.to_xml
```

## Serialization

```ruby
doc.to_xml            # XML declaration + canonical output
```
