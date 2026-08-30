# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Newsmlg2::Builder do
  describe 'news item construction' do
    subject(:doc) do
      Newsmlg2.build_news_item(guid: 'urn:newsml:acme.com:20260830:00001',
                               lang: 'en-GB') do |item|
        item.item_meta do |meta|
          meta.item_class qcode: 'ninat:text'
          meta.provider qcode: 'nprov:acme' do |p|
            p.name 'Acme News Agency'
          end
          meta.version_created '2026-08-30T12:00:00+00:00'
        end
        item.content_meta do |cm|
          cm.urgency 2
          cm.content_created '2026-08-30T11:00:00+00:00'
          cm.located qcode: 'geo:Berlin' do |l|
            l.name 'Berlin'
            l.broader qcode: 'geo:Germany' do |b|
              b.name 'Germany'
            end
          end
          cm.headline 'Eruption of Icelandic volcano'
          cm.subject qcode: 'medtop:20000962' do |s|
            s.name 'Volcano'
            s.name 'Vulkan', xml_lang: 'de'
          end
        end
      end
    end

    it 'builds a typed document' do
      expect(doc).to be_a(Newsmlg2::Document)
      expect(doc.item).to be_a(Newsmlg2::NewsItem)
      expect(doc.item.guid).to eq('urn:newsml:acme.com:20260830:00001')
      expect(doc.item.xml_lang).to eq('en-GB')
    end

    it 'coerces strings into content-bearing types' do
      expect(doc.item.item_meta.version_created.text)
        .to eq('2026-08-30T12:00:00+00:00')
      expect(doc.item.content_meta.urgency.text).to eq('2')
      expect(doc.item.item_meta.provider.names.first.text)
        .to eq('Acme News Agency')
    end

    it 'supports nested blocks three levels deep' do
      located = doc.item.content_meta.located.first
      expect(located.names.first.text).to eq('Berlin')
      expect(located.broader.first.names.first.text).to eq('Germany')
    end

    it 'appends to collections on repeated calls' do
      names = doc.item.content_meta.subjects.first.names
      expect(names.map(&:text)).to eq(%w[Volcano Vulkan])
      expect(names.map(&:xml_lang)).to eq([nil, 'de'])
    end

    it 'produces the same XML as the equivalent hand-built tree' do
      hand_built = Newsmlg2::Document.new(
        Newsmlg2::NewsItem.new(
          guid: 'urn:newsml:acme.com:20260830:00001',
          xml_lang: 'en-GB',
          item_meta: Newsmlg2::ItemMeta.new(
            item_class: Newsmlg2::Types::QualRelPropType.new(qcode: 'ninat:text'),
            provider: Newsmlg2::Types::FlexPartyPropType.new(
              qcode: 'nprov:acme',
              names: [Newsmlg2::Types::ConceptNameType.new(text: 'Acme News Agency')]
            ),
            version_created: Newsmlg2::Types::DateTimePropType.new(
              text: '2026-08-30T12:00:00+00:00'
            )
          )
        )
      )
      expect(doc.item.item_meta.to_xml).to eq(hand_built.item.item_meta.to_xml)
    end
  end

  describe 'every item type is buildable' do
    it 'supports all factories' do
      {
        Newsmlg2::Builder => nil
      }
      expect(Newsmlg2.build_package_item(guid: 'g').item)
        .to be_a(Newsmlg2::PackageItem)
      expect(Newsmlg2.build_concept_item(guid: 'g').item)
        .to be_a(Newsmlg2::ConceptItem)
      expect(Newsmlg2.build_knowledge_item(guid: 'g').item)
        .to be_a(Newsmlg2::KnowledgeItem)
      expect(Newsmlg2.build_catalog_item(guid: 'g').item)
        .to be_a(Newsmlg2::CatalogItem)
      expect(Newsmlg2.build_planning_item(guid: 'g').item)
        .to be_a(Newsmlg2::PlanningItem)
      expect(Newsmlg2.build_news_message.item)
        .to be_a(Newsmlg2::NewsMessage)
    end

    it 'builds newsMessage headers' do
      doc = Newsmlg2.build_news_message do |msg|
        msg.header do |h|
          h.sent '2026-08-30T12:00:00Z'
          h.sender 'acme.com'
        end
      end
      expect(doc.item.header.sent.text).to eq('2026-08-30T12:00:00Z')
      expect(doc.item.header.sender.text).to eq('acme.com')
    end
  end

  describe 'errors' do
    it 'raises NoMethodError for unknown attributes' do
      expect do
        Newsmlg2.build_news_item(guid: 'g') { |i| i.frobnicate 'x' }
      end.to raise_error(NoMethodError, /frobnicate/)
    end
  end

  describe 'built documents validate' do
    it 'produces schema-valid XML for a realistic news item' do
      xml = Newsmlg2.build_news_item(guid: 'urn:newsml:acme.com:20260830:00001') do |item|
        item.item_meta do |meta|
          meta.item_class qcode: 'ninat:text'
          meta.provider qcode: 'nprov:acme'
          meta.version_created '2026-08-30T12:00:00+00:00'
        end
        item.content_meta do |cm|
          cm.headline 'Test headline'
        end
      end.to_xml

      schema = Nokogiri::XML::Schema(File.open(
                                       'spec/fixtures/iptc/schema_versions/NewsML-G2_2.35-spec-All-Power.xsd'
                                     ))
      errors = schema.validate(Nokogiri::XML(xml.sub('<?xml version="1.0" encoding="UTF-8"?>', '')))
      expect(errors.map(&:message)).to be_empty,
                                       "schema invalid: #{errors.map(&:message).join(' | ')}"
    end
  end
end
