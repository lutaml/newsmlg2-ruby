# frozen_string_literal: true

# Port of python-newsmlg2 tests/test_packageitems.py.
require 'spec_helper'

RSpec.describe 'python test_packageitems' do
  describe 'LISTING_6' do
    let(:doc) { Newsmlg2.parse_file('spec/fixtures/python/test_files/LISTING_6_Simple_NewsML-G2_Package.xml') }
    let(:item) { doc.item }

    it 'reads item attributes and itemMeta' do
      expect(item).to be_a(Newsmlg2::PackageItem)
      expect(item.guid).to eq('tag:example.com,2008:UK-NEWS-TOPTEN:UK20081220098658')
      expect(item.standardversion).to eq('2.35')
      expect(item.version).to eq('11')

      scheme = doc.catalog_store.get_scheme_for_alias('prov')
      expect(scheme.uri).to eq('http://cv.iptc.org/newscodes/provider/')
      expect(scheme.authority).to eq('https://iptc.org/')

      item_meta = item.item_meta
      expect(item_meta.item_class.qcode).to eq('ninat:composite')
      expect(Newsmlg2.qcode_to_uri(item_meta.item_class.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/ninature/composite')
      expect(item_meta.provider.qcode).to eq('nprov:IPTC')
      expect(item_meta.version_created.text).to eq('2018-11-17T12:30:00Z')
      expect(item_meta.pub_status.qcode).to eq('stat:usable')
      expect(Newsmlg2.qcode_to_uri(item_meta.pub_status.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/pubstatusg2/usable')
    end

    it 'reads groupSet with group and itemRef' do
      group_set = item.group_set
      expect(group_set.root).to eq('G1')
      group = group_set.groups.first
      expect(group.id).to eq('G1')
      expect(group.role).to eq('group:main')
      item_ref = group.item_refs.first
      expect(item_ref.residref).to eq('urn:newsml:iptc.org:20081007:tutorial-item-A')
      expect(item_ref.contenttype).not_to be_nil
    end

    it 'reads contentMeta contributor with jobtitle, names and definition' do
      cm = item.content_meta
      contributor = cm.contributors.first
      expect(contributor.jobtitle).to eq('staffjobs:cpe')
      expect(contributor.qcode).to eq('mystaff:MDancer')
      expect(contributor.names.map(&:text))
        .to eq(['Maurice Dancer', 'Chief Packaging Editor'])
      expect(contributor.definitions.first.to_s).to eq('Duty Packaging Editor')
    end
  end
end
