# frozen_string_literal: true

# Port of python-newsmlg2 tests/test_newsmessage.py (file test; the string
# test uses the same content as fixture 007).
require 'spec_helper'

RSpec.describe 'python test_newsmessage' do
  let(:doc) { Newsmlg2.parse_file('spec/fixtures/python/test_files/007_emptynewsmessage.xml') }
  let(:item) { doc.item }
  let(:header) { item.header }

  it 'reads the header' do
    expect(item).to be_a(Newsmlg2::NewsMessage)
    expect(header.sent.text).to eq('2018-10-19T11:17:00.150Z')
    expect(header.catalog_refs[0].href).to eq('http://www.example.com/std/catalog/NewsNessages_1.xml')
    expect(header.catalog_refs[1].href)
      .to eq('http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_41.xml')
    expect(header.sender.text).to eq('thomsonreuters.com')
    expect(header.transmit_id.text).to eq('tag:reuters.com,2016:newsml_OVE48850O-PKG')
    expect(header.priority.text).to eq('4')
    expect(header.origin.text).to eq('MMS_3')
    expect(header.destinations.first.role).to eq('nmdest:foobar')
    expect(header.destinations.first.text).to eq('UKI')
    expect(header.channels.map(&:text)).to eq(%w[TVS TTT WWW])
    expect(header.timestamps[0].role).to eq('received')
    expect(header.timestamps[0].text).to eq('2018-10-19T11:17:00.000Z')
    expect(header.timestamps[1].role).to eq('transmitted')
    expect(header.timestamps[1].text).to eq('2018-10-19T11:17:00.100Z')
    expect(header.signals.first.qcode).to eq('nmsig:atomic')
  end

  it 'resolves header catalogRefs into the document catalog store' do
    expect(doc.catalog_store.get_scheme_for_alias('ninat').uri)
      .to eq('http://cv.iptc.org/newscodes/ninature/')
  end

  it 'exposes typed items from the raw itemSet' do
    expect(item.item_set.items.map { |i| i.class.name })
      .to eq(['Newsmlg2::PackageItem', 'Newsmlg2::NewsItem'])
  end
end
