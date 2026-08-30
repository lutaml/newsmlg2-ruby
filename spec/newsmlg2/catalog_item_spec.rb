# frozen_string_literal: true

# Port of python-newsmlg2 tests/test_catalogitems.py.
require 'spec_helper'

RSpec.describe 'python test_catalogitems' do
  let(:xml) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <catalogItem
          xmlns="http://iptc.org/std/nar/2006-10-01/"
          guid="urn:newsml:iptc.org:20130517:catalog"
          version="31"
          standard="NewsML-G2"
          standardversion="2.35"
          conformance="power"
          xml:lang="en-GB">
          <catalogRef href="http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_36.xml" />
          <rightsInfo>
              <copyrightHolder uri="http://www.iptc.org">
                  <name>IPTC</name>
              </copyrightHolder>
          </rightsInfo>
          <itemMeta>
              <itemClass qcode="catinat:catalog" />
              <provider qcode="nprov:IPTC">
                  <name>International Press Telecommunications Council</name>
              </provider>
              <versionCreated>2018-10-17T12:00:00Z</versionCreated>
              <pubStatus qcode="stat:usable" />
          </itemMeta>
          <catalogContainer>
              <catalog xmlns="http://iptc.org/std/nar/2006-10-01/"
                  additionalInfo="http://www.iptc.org/goto?G2cataloginfo">
                  <scheme alias="app" uri="http://cv.iptc.org/newscodes/application/">
                      <definition xml:lang="en-GB">Indicates how the metadata
                         value was applied.</definition>
                      <name xml:lang="en-GB">Application of Metadata Values</name>
                  </scheme>
                  <scheme alias="foo" uri="http://cv.iptc.org/newscodes/foo/">
                      <definition xml:lang="en-GB">Indicates how the metadata
                         value was applied.</definition>
                      <name xml:lang="en-GB">Application of Metadata Values</name>
                  </scheme>
              </catalog>
          </catalogContainer>
      </catalogItem>
    XML
  end
  let(:doc) { Newsmlg2.parse(xml) }
  let(:item) { doc.item }

  it 'parses the catalog item with its embedded catalog' do
    expect(item).to be_a(Newsmlg2::CatalogItem)
    expect(item.guid).to eq('urn:newsml:iptc.org:20130517:catalog')
    expect(item.version).to eq('31')
    expect(item.rights_infos.first.copyright_holder.uri).to eq('http://www.iptc.org')
    expect(item.item_meta.provider.qcode).to eq('nprov:IPTC')

    catalog = item.catalog_container.catalog
    expect(catalog.additionalinfo).to eq('http://www.iptc.org/goto?G2cataloginfo')
    expect(catalog.schemes.length).to eq(2)
    expect(catalog.get_scheme_for_alias('app').uri)
      .to eq('http://cv.iptc.org/newscodes/application/')
    expect(catalog.get_scheme_for_alias('foo').uri).to eq('http://cv.iptc.org/newscodes/foo/')

    expect(doc.catalog_store.length).to eq(1)
  end

  describe 'LISTING_13' do
    let(:doc) { Newsmlg2.parse_file('spec/fixtures/python/test_files/LISTING_13_Complete_Catalog_Item.xml') }

    it 'parses the complete catalog' do
      expect(doc.item).to be_a(Newsmlg2::CatalogItem)
      expect(doc.item.catalog_container.catalog.schemes.length).to eq(1)
      scheme = doc.catalog_store.get_scheme_for_alias('ninat')
      expect(scheme.uri).to eq('http://cv.iptc.org/newscodes/ninature/')
    end
  end
end
