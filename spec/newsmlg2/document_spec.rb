# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Newsmlg2::Document do
  let(:news_item_xml) do
    <<~XML
      <newsItem xmlns="http://iptc.org/std/nar/2006-10-01/" guid="test-guid">
        <catalogRef href="http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_40.xml" title="IPTC catalog"/>
        <itemMeta>
          <itemClass qcode="ninat:text"/>
          <provider qcode="nprov:acme"><name>Acme</name></provider>
          <versionCreated>2020-06-22T12:00:00+03:00</versionCreated>
        </itemMeta>
      </newsItem>
    XML
  end

  describe '.parse dispatch' do
    it 'parses a newsItem into a typed NewsItem' do
      doc = described_class.parse(news_item_xml)
      expect(doc.item).to be_a(Newsmlg2::NewsItem)
      expect(doc.item.guid).to eq('test-guid')
      expect(doc.item.item_meta.item_class.qcode).to eq('ninat:text')
    end

    it 'parses every item root type' do
      {
        'packageItem' => Newsmlg2::PackageItem,
        'conceptItem' => Newsmlg2::ConceptItem,
        'knowledgeItem' => Newsmlg2::KnowledgeItem,
        'catalogItem' => Newsmlg2::CatalogItem,
        'planningItem' => Newsmlg2::PlanningItem,
        'newsMessage' => Newsmlg2::NewsMessage
      }.each do |root, klass|
        doc = described_class.parse(
          "<#{root} xmlns=\"http://iptc.org/std/nar/2006-10-01/\" guid=\"g-#{root}\"/>"
        )
        expect(doc.item).to be_a(klass), "expected #{root} to parse into #{klass}"
      end
    end

    it 'raises for a non-NewsML-G2 root element' do
      expect do
        described_class.parse('<html xmlns="http://www.w3.org/1999/xhtml"><body/></html>')
      end.to raise_error(Newsmlg2::UnknownRootElement, /html/)
    end
  end

  describe 'unresolvable configured adapter (fresh install)' do
    it 'parses and serializes through the stdlib rexml fallback' do
      doc_class = nil
      serialized = Lutaml::Model::Config.with_adapter(xml: :leptris) do
        doc = described_class.parse(news_item_xml)
        doc_class = doc.item.class
        doc.to_xml
      end

      expect(doc_class).to be(Newsmlg2::NewsItem)
      expect(serialized).to start_with('<?xml version="1.0" encoding="UTF-8"?>')
      expect(serialized).to include('guid="test-guid"')
    end
  end

  describe '.parse_file' do
    it 'parses a file from disk' do
      doc = Newsmlg2::Document.parse_file(
        'spec/fixtures/python/test_files/001_simplest_file.xml'
      )
      expect(doc.item).to be_a(Newsmlg2::NewsItem)
      expect(doc.item.guid).to eq('simplest-test-from-file')
    end
  end

  describe 'catalog store wiring' do
    it 'resolves catalogRef through the bundled IPTC catalogs' do
      doc = described_class.parse(news_item_xml)
      expect(doc.catalog_store.get_scheme_for_alias('ninat').uri)
        .to eq('http://cv.iptc.org/newscodes/ninature/')
      expect(Newsmlg2.qcode_to_uri('ninat:text', doc))
        .to eq('http://cv.iptc.org/newscodes/ninature/text')
    end

    it 'reads inline catalogs' do
      xml = <<~XML
        <newsItem xmlns="http://iptc.org/std/nar/2006-10-01/" guid="g1">
          <catalog><scheme alias="myx" uri="http://example.test/x/"/></catalog>
          <itemMeta>
            <itemClass qcode="ninat:text"/>
            <provider qcode="nprov:acme"/>
            <versionCreated>2020-06-22T12:00:00+03:00</versionCreated>
          </itemMeta>
        </newsItem>
      XML
      doc = described_class.parse(xml)
      expect(doc.catalog_store.get_scheme_for_alias('myx').uri).to eq('http://example.test/x/')
      expect(Newsmlg2.uri_to_qcode('http://example.test/x/foo', doc)).to eq('myx:foo')
    end
  end

  describe '#to_xml' do
    it 'serializes with declaration and defaults' do
      doc = described_class.parse(news_item_xml)
      xml = doc.to_xml
      expect(xml).to start_with('<?xml version="1.0" encoding="UTF-8"?>')
      expect(xml).to include('<newsItem ')
      expect(xml).to include('guid="test-guid"')
      expect(xml).to include('standard="NewsML-G2"')
    end

    it 'round-trips idempotently (canonical output is stable)' do
      once = described_class.parse(news_item_xml).to_xml
      twice = described_class.parse(once).to_xml
      expect(twice).to eq(once)
    end

    it 'round-trips a fully-defaulted document semantically' do
      defaulted = described_class.parse(news_item_xml).to_xml
      expect("<r>#{described_class.parse(defaulted).to_xml}</r>")
        .to be_xml_equivalent_to("<r>#{defaulted}</r>")
    end

    it 'raises for an item without a guid' do
      item = Newsmlg2::NewsItem.new
      expect { described_class.new(item).to_xml }
        .to raise_error(Newsmlg2::MissingGuidError)
    end
  end

  describe Newsmlg2::ItemSet do
    it 'exposes typed items from raw itemSet content' do
      doc = Newsmlg2::Document.parse_file(
        'spec/fixtures/python/test_files/007_emptynewsmessage.xml'
      )
      expect(doc.item).to be_a(Newsmlg2::NewsMessage)
      expect(doc.item.item_set.items.map { |i| i.class.name })
        .to contain_exactly('Newsmlg2::PackageItem', 'Newsmlg2::NewsItem')
    end
  end
end
