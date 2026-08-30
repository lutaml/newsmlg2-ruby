# frozen_string_literal: true

# Port of python-newsmlg2 tests/test_conceptitems.py and tests/test_events.py.
require 'spec_helper'

RSpec.describe 'python test_conceptitems / test_events' do
  describe 'from string with eventDetails' do
    let(:xml) do
      <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <conceptItem
            xmlns="http://iptc.org/std/nar/2006-10-01/"
            guid="conceptitem-string-test"
            standard="NewsML-G2"
            standardversion="2.24"
            conformance="power"
            xml:lang="en-GB">
            <catalogRef href="http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_36.xml"/>
            <itemMeta>
                <itemClass qcode="cinat:concept"/>
                <provider literal="reuters.com"/>
                <versionCreated>2019-09-09T08:00:00.000Z</versionCreated>
            </itemMeta>
            <concept>
                <conceptId qcode="P:111"/>
                <type qcode="cptType:37"/>
                <name>Event111:Name</name>
                <eventDetails>
                    <dates>
                        <start confirmationstatus="edconf:approximate">2016-06-25T10:00:00Z</start>
                        <end confirmationstatus="edconf:undefined">2016</end>
                        <confirmation qcode="edconf:bothApprox"/>
                    </dates>
                </eventDetails>
            </concept>
        </conceptItem>
      XML
    end
    let(:doc) { Newsmlg2.parse(xml) }
    let(:item) { doc.item }

    it 'reads item attributes and itemMeta' do
      expect(item).to be_a(Newsmlg2::ConceptItem)
      expect(item.guid).to eq('conceptitem-string-test')
      expect(item.standard).to eq('NewsML-G2')
      expect(item.standardversion).to eq('2.24')
      expect(item.conformance).to eq('power')
      expect(item.version).to eq('1')
      expect(item.xml_lang).to eq('en-GB')

      item_meta = item.item_meta
      expect(item_meta.item_class.qcode).to eq('cinat:concept')
      expect(Newsmlg2.qcode_to_uri(item_meta.item_class.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/cinature/concept')
      expect(item_meta.provider.literal).to eq('reuters.com')
      expect(item_meta.version_created.text).to eq('2019-09-09T08:00:00.000Z')
    end

    it "reads the catalog via the 'prov' alias" do
      scheme = doc.catalog_store.get_scheme_for_alias('prov')
      expect(scheme.uri).to eq('http://cv.iptc.org/newscodes/provider/')
      expect(scheme.authority).to eq('https://iptc.org/')
      expect(scheme.modified).to eq('2019-09-13T12:00:00+00:00')
      expect(scheme.definitions.first.to_s)
        .to eq('Indicates a company, publication or service provider.')
    end

    it 'reads concept, dates and confirmation' do
      concept = item.concept
      expect(concept.concept_id.qcode).to eq('P:111')
      expect(concept.type.qcode).to eq('cptType:37')
      expect(concept.names.first.text).to eq('Event111:Name')

      dates = concept.event_details.dates
      expect(dates.start.text).to eq('2016-06-25T10:00:00Z')
      expect(dates.start.confirmationstatus).to eq('edconf:approximate')
      expect(dates.end.text).to eq('2016')
      expect(dates.end.confirmationstatus).to eq('edconf:undefined')
      expect(dates.confirmation.qcode).to eq('edconf:bothApprox')
    end
  end

  describe 'from file 003' do
    let(:doc) { Newsmlg2.parse_file('spec/fixtures/python/test_files/003_conceptitem.xml') }
    let(:item) { doc.item }

    it 'reads attributes, catalogs and itemMeta' do
      expect(item.guid).to eq('003-concept-item-file-test')
      expect(item.standardversion).to eq('2.35')

      scheme = doc.catalog_store.get_scheme_for_alias('nprov')
      expect(scheme.uri).to eq('http://cv.iptc.org/newscodes/newsprovider/')
      expect(scheme.authority).to eq('https://iptc.org/')

      item_meta = item.item_meta
      expect(item_meta.item_class.qcode).to eq('cinat:concept')
      expect(Newsmlg2.qcode_to_uri(item_meta.item_class.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/cinature/concept')
      expect(item_meta.provider.qcode).to eq('nprov:IPTC')
      expect(item_meta.version_created.text).to eq('2020-06-22T12:00:00+03:00')
    end
  end

  describe 'from file 005 (personDetails)' do
    let(:doc) { Newsmlg2.parse_file('spec/fixtures/python/test_files/005_conceptitem_persondetails.xml') }
    let(:item) { doc.item }
    let(:concept) { item.concept }
    let(:person) { concept.person_details }

    it 'reads item attributes' do
      expect(item.guid).to eq('urn:newsml:iptc.org:005-conceptitem-with-persondetails-test')
      expect(item.standardversion).to eq('2.35')
      expect(item.item_meta.version_created.text).to eq('2018-11-07T12:38:18Z')
    end

    it 'reads concept definition, note, related and sameAs' do
      expect(concept.concept_id.qcode).to eq('people:329465')
      expect(concept.type.qcode).to eq('cpnat:person')
      expect(concept.names.first.text).to eq('Mario Draghi')
      expect(concept.definitions.first.role).to eq('definitionrole:biog')
      expect(concept.definitions.first.to_s).to start_with('Mario Draghi, born 3 September 1947,')
      expect(concept.notes.first.role).to eq('nrol:disambiguation')
      expect(concept.notes.first.to_s)
        .to eq('Not Mario D’roggia, international powerboat racer')
      expect(concept.related.first.rel).to eq('relation:occupation')
      expect(concept.related.first.qcode).to eq('jobtypes:puboff')
      expect(concept.same_as.first.type).to eq('cpnat:person')
      expect(concept.same_as.first.qcode).to eq('pers:567223')
      expect(concept.same_as.first.names.first.text).to eq('DRAGHI, Mario')
    end

    it 'reads personDetails: born, affiliation, contactInfo' do
      expect(person.born.text).to eq('1947-09-03')
      affiliation = person.affiliations.first
      expect(affiliation.type).to eq('orgnat:employer')
      expect(affiliation.qcode).to eq('org:ECB')
      expect(affiliation.names.first.text).to eq('European Central Bank')

      contact = person.contact_infos.first
      expect(contact.emails.first.role).to eq('ciprol:office')
      expect(contact.emails.first.text).to eq('info@ecb.eu')
      expect(contact.ims.first.role).to eq('imsrvc:reuters')
      expect(contact.ims.first.text).to eq('president.ecb.eu@reuters.net')
      expect(contact.phones.length).to eq(2)
      expect(contact.phones[0].role).to eq('ciprol:office')
      expect(contact.phones[0].text).to eq('+49 69 13 44 0')
      expect(contact.phones[1].role).to eq('ciprol:mobile')
      expect(contact.phones[1].text).to eq('+49 69 13 44 60 00')
      expect(contact.webs.first.text).to eq('www.ecb.eu')
      address = contact.addresses.first
      expect(address.role).to eq('ciprol:office')
      expect(address.lines.first.text).to eq('Kaiserstrasse 29')
      expect(address.localities.first.names.first.text).to eq('Frankfurt am Main')
      expect(address.country.qcode).to eq('iso3166-1a2:DE')
      expect(address.country.names.first.text).to eq('Germany')
      expect(address.postal_code.text).to eq('D-60311')
    end
  end

  describe 'from file 006 (geoAreaDetails)' do
    let(:doc) { Newsmlg2.parse_file('spec/fixtures/python/test_files/006_conceptitem_geoareadetails.xml') }
    let(:item) { doc.item }
    let(:geo) { item.concept.geo_area_details }

    it 'reads itemMeta including title' do
      expect(item.guid).to eq('urn:newsml:iptc.org:006-conceptitem-with-geoareadetails-test')
      expect(item.item_meta.titles.first.to_s).to eq('Concept Item describing Kentucky')
    end

    it 'reads geoAreaDetails: position, founded, dissolved, polygon' do
      expect(item.concept.concept_id.qcode)
        .to eq('apgeography:2f6e294082b310048474df092526b43e')
      expect(item.concept.type.qcode).to eq('cpnat:geoArea')
      expect(item.concept.names.first.text).to eq('Kentucky')

      expect(geo.position.latitude).to eq('-84.87762')
      expect(geo.position.longitude).to eq('38.20042')
      expect(geo.founded.text).to eq('1792-06-01')
      expect(geo.dissolved.text).to eq('2099-12-31')
      polygon = geo.polygons.first
      expect(polygon.positions[0].latitude).to eq('-89.57291911219112')
      expect(polygon.positions[0].longitude).to eq('36.49707311372113')
      expect(polygon.positions[1].latitude).to eq('-81.96720514115141')
    end
  end
end
