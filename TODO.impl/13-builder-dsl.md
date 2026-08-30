# 13 — Builder DSL for writing NewsML-G2

Depends on: 09 (full model layer), 10 (python tests ported — the DSL must not
perturb them).

## Goal

Provide a block-based DSL so users can write NewsML-G2 documents without
hand-assembling model trees. **The DSL is generic**: node behavior derives from
each model's lutaml-model attribute/mapping metadata at runtime. No per-class
builder code, no `method_missing` guessing on models themselves.

Context: `/Users/mulgogi/src/mn/metanorma-document/` was checked and has **no**
builder DSL to copy — this design is original, deliberately OCP: adding model
classes automatically extends the builder.

## Target UX

```ruby
require "newsmlg2"

doc = Newsmlg2.build_news_item(guid: "urn:newsml:acme.com:20260830T120000+0000:xyz",
                               lang: "en-GB") do |item|
  item.item_meta do |meta|
    meta.item_class qcode: "ninat:text"
    meta.provider qcode: "nprov:acme" do |p|
      p.name "Acme News Agency"
    end
    meta.version_created "2026-08-30T12:00:00+00:00"
  end
  item.content_meta do |cm|
    cm.urgency 2
    cm.headline "Volcano erupts in Iceland"
    cm.slugline "ICELAND-VOLCANO"
    cm.creator qcode: "CreatorCode" do |c|
      c.name "Acme Reporter"
    end
    cm.subject qcode: "medtop:20000962" do |s|
      s.name "Volcano"
    end
    cm.description "Lava flows reported near Grindavik."
  end
  item.content_set do |cs|
    cs.inline_xml "<nitf>…</nitf>"
  end
end

doc.to_xml   # Newsmlg2::Document, ready
```

## Mechanism

- `Newsmlg2.build_news_item` / `build_package_item` / `build_concept_item` /
  `build_knowledge_item` / `build_catalog_item` / `build_planning_item` /
  `build_news_message` — thin factories in `lib/newsmlg2/builder.rb`:
  instantiate the model, apply kwarg shortcuts (`lang:` → `xml:lang`,
  `guid:`, `version:`…), wrap in a node, `instance_eval` the block, return
  `Newsmlg2::Document` with the item set.
- `Newsmlg2::Builder::Node` (`lib/newsmlg2/builder/node.rb`) wraps one model:
  - for each attribute of `model.class.attributes`, define a method
    `foo(value = nil, **attrs, &block)`:
      - `String`/value arg on a content-bearing scalar type → wrap into the
        type (`meta.version_created "2026-…"` ≡ `.new(text: …)`) — ports
        python's `located.name = 'Berlin'` sugar;
      - kwargs build the child model (`meta.item_class qcode: "ninat:text"`);
      - block descends (`Builder::Node.wrap(child)`), enabling nesting;
      - collections: repeated calls append (`cm.subject …` twice → array of 2);
      - scalar re-set overwrites (with a warning? no — silently overwrite,
        matching Ruby assignment semantics; document it);
      - unknown method → `NoMethodError` (fail loudly; never guess);
  - node returns the *model* it built (so `doc.item` is the plain model);
    blocks return the child node for chaining where useful.
- qcode/string coercion rules live in one place
  (`Builder::Coercion`) — e.g. value `2` for urgency becomes the content
  model; integers/floats to_s for content types.
- Metadata source: `model.class.attributes` + the XML mapping (to know wire
  names for kwargs like `contenttype:`). Never re-declare per-class knowledge.

## Deliverables

- `lib/newsmlg2/builder.rb`, `lib/newsmlg2/builder/node.rb`,
  `lib/newsmlg2/builder/coercion.rb` (+ autoload wiring).
- `spec/newsmlg2/builder_spec.rb`:
  1. builder-built NewsItem serializes to XML identical (string equality) to
     the same tree constructed via plain `.new(attrs)` constructors;
  2. every item type is buildable (smoke test each `build_*`);
  3. collections append; blocks nest ≥3 deep (subject → name → broader);
  4. content coercion (string → typed content model) both scalar and
     collection;
  5. kwarg shortcuts (`lang:` → xml:lang);
  6. unknown method raises NoMethodError with the model class named;
  7. builder output for a realistic document (reuse the python README example
     news item) validates against the 2.35 All-Power XSD.

## Acceptance

- All builder specs green; python-port suite (plan 10) unaffected.
- README example (to be written in plan 14) uses only DSL + `to_xml`.

## Risks

- Attribute-name collisions with `Node`'s own methods: prefix nothing —
  instead define node methods in a blank-slate delegator class; verify with
  a model having a `text`/`content` attribute.


## Status: COMPLETE

Implemented in `lib/newsmlg2/base/`, `lib/newsmlg2/types/`, `lib/newsmlg2/items/`.
The per-class inventories are embodied in the code: every python class maps to a Ruby
class named after its XSD type (element names declared once at usage sites). Deviations
from python (all XSD-driven or cycle-driven) are documented in the source comments:
FlexOrganisationPropType replaced by the composed Types::Affiliation; the two identical
python affiliation classes collapsed into one; ItemSet uses raw xs:any capture with a
typed #items accessor; Assert captures xs:any content raw; contentMeta carries a
modelled `names` element for the fixture quirk.
