# frozen_string_literal: true

# Compliance over the official IPTC NewsML-G2 example documents
# (spec/fixtures/iptc/examples, vendored from iptc/newsml-g2 examples/).
require 'spec_helper'
require_relative '../support/roundtrip_helper'

RSpec.describe 'IPTC official examples' do
  include RoundtripHelper

  EXAMPLES = Pathname.new('spec/fixtures/iptc/examples')
  # The groupSet listings are bare fragments without a namespace
  # declaration; our serializer (correctly) emits them in the NAR
  # namespace, so fragment comparison is namespace-insensitive.
  FRAGMENTS = {
    'LISTING_25_An_NITF_marked-up_article_conveyed_in_inlineXML.xml' => Newsmlg2::ContentSet,
    'LISTING_28_Illustrating_Located_Subject_and_Dateline.xml' => Newsmlg2::ContentMeta,
    'LISTING_7_Group_Set_example_showing_Hierarchical_Package_Structure.xml' => Newsmlg2::GroupSet,
    'LISTING_8_Group_Set_example_showing_an_ALT_Package_Mode.xml' => Newsmlg2::GroupSet,
    'LISTING_9_Group_Set_example_showing_a_SEQ_Package_Mode.xml' => Newsmlg2::GroupSet
  }.freeze

  ROOT_CLASSES = {
    'newsItem' => Newsmlg2::NewsItem,
    'packageItem' => Newsmlg2::PackageItem,
    'conceptItem' => Newsmlg2::ConceptItem,
    'knowledgeItem' => Newsmlg2::KnowledgeItem,
    'catalogItem' => Newsmlg2::CatalogItem,
    'planningItem' => Newsmlg2::PlanningItem,
    'newsMessage' => Newsmlg2::NewsMessage
  }.freeze

  def root_name(xml)
    require 'nokogiri'
    Nokogiri::XML(xml).root.name
  end

  it 'covers the full example set' do
    expect(Dir[EXAMPLES.join('*.xml')].length).to eq(35)
  end

  Dir[EXAMPLES.join('*.xml')].each do |path|
    name = File.basename(path)

    it "round-trips #{name}" do
      source = File.read(path)
      fragment_class = FRAGMENTS[name]

      if fragment_class
        fragment = fragment_class.from_xml(source)
        once = fragment.to_xml
        expect(fragment_class.from_xml(once).to_xml).to eq(once)
        expect(XmlOrderNormalizer.normalize(once, strip_namespaces: true))
          .to be_xml_equivalent_to(XmlOrderNormalizer.normalize(source, strip_namespaces: true))
      else
        doc = Newsmlg2.parse(source)
        klass = ROOT_CLASSES[root_name(source)]
        expect(klass).not_to be_nil, "no root class for #{name}"
        expect(doc.item).to be_a(klass)
        once = expect_idempotent_roundtrip(source)
        # LISTING_24 takes liberties the XSD does not allow: dot-run
        # placeholders for item content, and itemRef children directly
        # inside itemSet's packageItem (the XSD puts them in groupSet).
        # Typed models drop both (as python-newsmlg2 does), so strip them
        # from the comparison.
        compared = source.gsub(/>\s*\.{3,}\s*</, '><')
                         .gsub(%r{<itemRef\s+residref="N\d+"\s*/>}, '')
        expect_no_information_loss(once, compared)
      end
    end
  end

  describe 'spot checks' do
    it 'LISTING_1 parses key content' do
      doc = Newsmlg2.parse_file(
        EXAMPLES.join('LISTING_1_A_NewsML-G2_News_Item.xml').to_s
      )
      item = doc.item
      expect(item.guid).to eq('urn:newsml:acmenews.com:20161018:US-FINANCE-FED')
      expect(item.item_meta.item_class.qcode).to eq('ninat:text')
      expect(item.content_meta.headlines.first.to_s)
        .to eq('Fed to halt QE to avert "bubble"')
    end

    it 'LISTING_5 parses partMeta with timeDelim' do
      doc = Newsmlg2.parse_file(
        EXAMPLES.join('LISTING_5_Multi-part_Video_in_NewsML-G2.xml').to_s
      )
      part_meta = doc.item.part_metas.first
      expect(part_meta).to be_a(Newsmlg2::PartMeta)
      expect(part_meta.time_delims.first.start).to eq('0')
    end

    it 'LISTING_13 parses the catalog item' do
      doc = Newsmlg2.parse_file(
        EXAMPLES.join('LISTING_13_Complete_Catalog_Item.xml').to_s
      )
      expect(doc.item).to be_a(Newsmlg2::CatalogItem)
    end

    it 'LISTING_29 parses hop history' do
      doc = Newsmlg2.parse_file(
        EXAMPLES.join('LISTING_29_Hop_History.xml').to_s
      )
      expect(doc.item.hop_history.hops.length).to be > 0
    end
  end
end
