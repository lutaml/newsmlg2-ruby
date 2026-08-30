# frozen_string_literal: true

# Port of python-newsmlg2 tests/test_knowledgeitems.py.
require 'spec_helper'

RSpec.describe 'python test_knowledgeitems' do
  describe 'from file 002' do
    let(:doc) { Newsmlg2.parse_file('spec/fixtures/python/test_files/002_knowledgeitem.xml') }
    let(:item) { doc.item }

    it 'reads item attributes and itemMeta' do
      expect(item).to be_a(Newsmlg2::KnowledgeItem)
      expect(item.guid).to eq('urn:newsml:iptc.org:20080229:srcncdki-nprov-TS202102091406532')
      expect(item.standard).to eq('NewsML-G2')
      expect(item.standardversion).to eq('2.35')
      expect(item.conformance).to eq('power')

      item_meta = item.item_meta
      expect(item_meta.item_class.qcode).to eq('cinat:scheme')
      expect(Newsmlg2.qcode_to_uri(item_meta.item_class.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/cinature/scheme')
      expect(item_meta.provider.uri).to eq('http://cv.iptc.org/newscodes/newsprovider/IPTC')
      expect(Newsmlg2.uri_to_qcode(item_meta.provider.uri, doc)).to eq('nprov:IPTC')
      expect(item_meta.version_created.text).to eq('2021-04-21T12:00:00+00:00')
    end

    it 'reads the catalog' do
      scheme = doc.catalog_store.get_scheme_for_alias('nprov')
      expect(scheme.uri).to eq('http://cv.iptc.org/newscodes/newsprovider/')
      expect(scheme.authority).to eq('https://iptc.org/')
      expect(scheme.modified).to eq('2019-09-13T12:00:00+00:00')
      expect(scheme.definitions.first.to_s)
        .to eq('Indicates a News Provider registered with the IPTC.')
    end

    it 'iterates the conceptSet' do
      concepts = item.concept_set.concepts
      expect(concepts.length).to eq(67)

      first = concepts[0]
      expect(first.id).to eq('nprovACCESSWIRE')
      expect(first.modified).to eq('2021-02-09T12:00:00+00:00')
      expect(first.concept_id.qcode).to eq('nprov:ACCESSWIRE')
      expect(Newsmlg2.qcode_to_uri(first.concept_id.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/newsprovider/ACCESSWIRE')
      expect(first.concept_id.created).to eq('2021-02-09T12:00:00+00:00')
      expect(first.type.qcode).to eq('cpnat:abstract')
      expect(Newsmlg2.qcode_to_uri(first.type.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/cpnature/abstract')
      expect(first.names.first.text).to eq('ACCESSWIRE')
      expect(first.names[0].xml_lang).to eq('en-GB')
      expect(first.related.first.uri).to eq('http://cv.iptc.org/newscodes/newsprovider/')
      expect(first.related.first.rel).to eq('skos:inScheme')

      second = concepts[1]
      expect(second.id).to eq('nprovAFP')
      expect(second.modified).to eq('2008-07-02T12:00:00+00:00')
      expect(second.concept_id.qcode).to eq('nprov:AFP')
      expect(second.type.qcode).to eq('cpnat:abstract')
      expect(second.names[0].xml_lang).to eq('en-GB')
      expect(second.names[0].text).to eq('Agence France-Presse')
      expect(second.related.first.uri).to eq('http://cv.iptc.org/newscodes/newsprovider/')
      expect(second.related.first.rel).to eq('skos:inScheme')
    end
  end
end
