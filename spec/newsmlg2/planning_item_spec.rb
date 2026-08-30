# frozen_string_literal: true

# Port of python-newsmlg2 tests/test_planningitems.py and the file test of
# tests/test_events.py (which re-tests the planning item file).
require 'spec_helper'

RSpec.describe 'python test_planningitems' do
  describe 'from file 004' do
    let(:doc) { Newsmlg2.parse_file('spec/fixtures/python/test_files/004_planningitem.xml') }
    let(:item) { doc.item }

    it 'reads item attributes and itemMeta' do
      expect(item).to be_a(Newsmlg2::PlanningItem)
      expect(item.guid).to eq('urn:newsml:iptc.org:20211029:gbmdrmdreis4711')
      expect(item.standardversion).to eq('2.35')

      scheme = doc.catalog_store.get_scheme_for_alias('nprov')
      expect(scheme.uri).to eq('http://cv.iptc.org/newscodes/newsprovider/')
      expect(scheme.authority).to eq('https://iptc.org/')

      item_meta = item.item_meta
      expect(item_meta.item_class.qcode).to eq('plinat:newscoverage')
      expect(Newsmlg2.qcode_to_uri(item_meta.item_class.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/plinature/newscoverage')
      expect(item_meta.provider.qcode).to eq('nprov:IPTC')
      expect(item_meta.version_created.text).to eq('2021-10-29T12:45:00Z')
    end

    it 'reads newsCoverageSet with planning entries' do
      coverages = item.news_coverage_sets.first.news_coverages
      expect(coverages.length).to eq(2)
      expect(coverages[0].id).to eq('ID_1234568')
      expect(coverages[0].planning.first.ed_notes.first.to_s).to eq('Text 250 words')
      expect(coverages[1].id).to eq('ID_1234569')
      expect(coverages[1].planning.first.ed_notes.first.to_s)
        .to eq('Picture scheduled 2018-12-25T12:0:00-05:00')
    end
  end

  describe 'LISTING_19' do
    let(:doc) do
      Newsmlg2.parse_file('spec/fixtures/python/test_files/LISTING_19_Planning_Item_with_delivery_at_CCL.xml')
    end

    it 'parses and exposes news coverage with delivery' do
      expect(doc.item).to be_a(Newsmlg2::PlanningItem)
      coverage = doc.item.news_coverage_sets.first.news_coverages.first
      expect(coverage).to be_a(Newsmlg2::NewsCoverage)
    end
  end
end
