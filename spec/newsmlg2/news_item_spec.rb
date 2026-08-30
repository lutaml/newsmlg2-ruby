# frozen_string_literal: true

# Port of python-newsmlg2 tests/test_newsitems.py.
#
# Naming adaptations (documented in TODO.impl/10):
#   itemmeta -> item_meta, contentmeta -> content_meta, contentset -> content_set,
#   rightsinfo -> rights_infos.first, singular python elements read via .first,
#   str(element) -> element.text (plain content) or element.to_s (block/label),
#   NewsMLG2.qcode_to_uri(qcode) -> Newsmlg2.qcode_to_uri(qcode, doc).
require 'spec_helper'

RSpec.describe 'python test_newsitems' do
  let(:simplest_xml) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <newsItem
          xmlns="http://iptc.org/std/nar/2006-10-01/"
          guid="simplest-test"
          standard="NewsML-G2"
          standardversion="2.35"
          conformance="power"
          version="1"
          xml:lang="en-GB">
          <catalogRef href="http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_41.xml" />
          <itemMeta>
              <itemClass qcode="ninat:text" />
              <provider qcode="nprov:IPTC" />
              <versionCreated>2025-09-29T12:00:00+03:00</versionCreated>
          </itemMeta>
          <contentSet>
              <inlineXML contenttype="application/nitf+xml">
              </inlineXML>
          </contentSet>
      </newsItem>
    XML
  end

  describe 'from string' do
    it 'reads attributes, itemMeta and qcode conversion' do
      doc = Newsmlg2.parse(simplest_xml)
      newsitem = doc.item
      expect(newsitem.guid).to eq('simplest-test')
      expect(newsitem.standard).to eq('NewsML-G2')
      expect(newsitem.standardversion).to eq('2.35')
      expect(newsitem.conformance).to eq('power')

      item_meta = newsitem.item_meta
      expect(item_meta.item_class.qcode).to eq('ninat:text')
      expect(Newsmlg2.qcode_to_uri(item_meta.item_class.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/ninature/text')
      expect(item_meta.provider.qcode).to eq('nprov:IPTC')
      expect(Newsmlg2.qcode_to_uri(item_meta.provider.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/newsprovider/IPTC')
      expect(item_meta.version_created.text).to eq('2025-09-29T12:00:00+03:00')
    end
  end

  describe 'failure cases' do
    it 'rejects non-item assignment, unknown attributes and missing guid' do
      doc = Newsmlg2.parse(simplest_xml)
      expect { doc.item = 'foo' }.to raise_error(ArgumentError)

      newsitem = doc.item
      expect(newsitem.guid).to eq('simplest-test')
      expect(newsitem.dir).to be_nil
      expect { newsitem.foo = 'bar' }.to raise_error(NoMethodError)
    end
  end

  describe 'from file 001' do
    let(:doc) { Newsmlg2.parse_file('spec/fixtures/python/test_files/001_simplest_file.xml') }
    let(:newsitem) { doc.item }

    it 'reads attributes' do
      expect(newsitem.guid).to eq('simplest-test-from-file')
      expect(newsitem.standard).to eq('NewsML-G2')
      expect(newsitem.standardversion).to eq('2.35')
      expect(newsitem.conformance).to eq('power')
      expect(newsitem.xml_lang).to eq('en-GB')
    end

    it 'resolves catalogs from catalogRef' do
      scheme = doc.catalog_store.get_scheme_for_alias('nprov')
      expect(scheme.uri).to eq('http://cv.iptc.org/newscodes/newsprovider/')
      expect(scheme.authority).to eq('https://iptc.org/')
      expect(scheme.modified).to eq('2019-09-13T12:00:00+00:00')
      expect(scheme.definitions.first.to_s)
        .to eq('Indicates a News Provider registered with the IPTC.')
    end

    it 'reads itemMeta and contentSet' do
      item_meta = newsitem.item_meta
      expect(item_meta.item_class.qcode).to eq('ninat:text')
      expect(Newsmlg2.qcode_to_uri(item_meta.item_class.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/ninature/text')
      expect(item_meta.provider.qcode).to eq('nprov:IPTC')
      expect(item_meta.version_created.text).to eq('2020-06-22T12:00:00+03:00')
      expect(newsitem.content_set.inlinexml.first.contenttype).to eq('application/nitf+xml')
    end
  end

  describe 'LISTING_1' do
    let(:doc) { Newsmlg2.parse_file('spec/fixtures/python/test_files/LISTING_1_A_NewsML-G2_News_Item.xml') }
    let(:newsitem) { doc.item }

    it 'reads item attributes' do
      expect(newsitem.guid).to eq('urn:newsml:acmenews.com:20161018:US-FINANCE-FED')
      expect(newsitem.standard).to eq('NewsML-G2')
      expect(newsitem.standardversion).to eq('2.35')
      expect(newsitem.conformance).to eq('power')
      expect(newsitem.xml_lang).to eq('en-GB')
      expect(newsitem.version).to eq('11')
    end

    it 'reads rightsInfo' do
      rights = newsitem.rights_infos.first
      expect(rights.copyright_holder.uri).to eq('http://www.example.com/about.html#copyright')
      expect(rights.copyright_holder.names.first.text).to eq('Example Enews LLP')
      expect(rights.copyright_notices.first.to_s)
        .to eq('Copyright 2017-18 Example Enews LLP, all rights reserved')
      expect(rights.usage_terms.first.to_s).to eq('Not for use outside the United States')
    end

    it 'reads itemMeta including edNote, signal and link' do
      item_meta = newsitem.item_meta
      expect(item_meta.item_class.qcode).to eq('ninat:text')
      expect(Newsmlg2.qcode_to_uri(item_meta.item_class.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/ninature/text')
      expect(item_meta.provider.qcode).to eq('nprov:REUTERS')
      expect(Newsmlg2.qcode_to_uri(item_meta.provider.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/newsprovider/REUTERS')
      expect(item_meta.version_created.text).to eq('2018-10-21T16:25:32-05:00')
      expect(item_meta.first_created.text).to eq('2016-10-18T13:12:21-05:00')
      expect(item_meta.embargoed.text).to eq('2018-10-23T12:00:00Z')
      expect(item_meta.pub_status.qcode).to eq('stat:usable')
      expect(Newsmlg2.qcode_to_uri(item_meta.pub_status.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/pubstatusg2/usable')
      expect(item_meta.services.first.qcode).to eq('svc:uknews')
      # the 'svc' alias is not declared in the IPTC catalog
      expect { Newsmlg2.qcode_to_uri(item_meta.services.first.qcode, doc) }
        .to raise_error(Newsmlg2::AliasNotFoundInCatalogs)
      expect(item_meta.services.first.names.first.text).to eq('UK News Service')
      expect(item_meta.ed_notes.first.to_s)
        .to eq('Note to editors: STRICTLY EMBARGOED. Not for public release until ' \
               '12noon on Friday, October 23, 2018.')
      expect(item_meta.signals.first.qcode).to eq('sig:update')
      expect(Newsmlg2.qcode_to_uri(item_meta.signals.first.qcode, doc))
        .to eq('http://cv.iptc.org/newscodes/signal/update')
      link = item_meta.links.first
      expect(link.rel).to eq('irel:seeAlso')
      expect(Newsmlg2.qcode_to_uri(link.rel, doc))
        .to eq('http://cv.iptc.org/newscodes/itemrelation/seeAlso')
      expect(link.href).to eq('http://www.example.com/video/20081222-PNN-1517-407624/index.html')
    end

    it 'reads contentMeta with located hierarchy and multilingual subjects' do
      cm = newsitem.content_meta
      expect(cm.content_created.text).to eq('2016-10-18T11:12:00-05:00')
      expect(cm.content_modified.text).to eq('2018-10-21T16:22:45-05:00')
      located = cm.located.first
      expect(located.type).to eq('cptype:city')
      expect(located.qcode).to eq('geo:345678')
      expect(located.names.first.text).to eq('Berlin')
      expect(located.broader[0].type).to eq('cptype:statprov')
      expect(located.broader[0].qcode).to eq('prov:2365')
      expect(located.broader[0].names.first.text).to eq('Berlin')
      expect(located.broader[1].type).to eq('cptype:country')
      expect(located.broader[1].qcode).to eq('iso3166-1a2:DE')
      expect(located.broader[1].names.first.text).to eq('Germany')
      expect(located.broader.map { |b| b.names.first.text }).to eq(%w[Berlin Germany])

      expect(cm.creators.first.uri).to eq('http://www.example.com/staff/mjameson')
      expect(cm.creators.first.names.first.text).to eq('Meredith Jameson')
      expect(cm.info_sources.first.uri).to eq('http://www.example.com')

      expect(cm.subjects[0].type).to eq('cpnat:abstract')
      expect(cm.subjects[0].qcode).to eq('medtop:04000000')
      expect(cm.subjects[0].names[0].xml_lang).to eq('en-GB')
      expect(cm.subjects[0].names.first.text).to eq('economy, business and finance')
      expect(cm.subjects[1].type).to eq('cpnat:abstract')
      expect(cm.subjects[1].qcode).to eq('medtop:20000523')
      expect(cm.subjects[1].names[0].text).to eq('labour market')
      expect(cm.subjects[1].names[0].xml_lang).to eq('en-GB')
      expect(cm.subjects[1].names[1].text).to eq('Arbeitsmarkt')
      expect(cm.subjects[1].names[1].xml_lang).to eq('de')
      expect(cm.subjects[1].broader.first.qcode).to eq('medtop:04000000')

      # language helper functions
      expect(Newsmlg2::I18n.languages(cm.subjects[1].names)).to eq(%w[en-GB de])
      expect(Newsmlg2::I18n.for_language(cm.subjects[1].names, 'en-GB').text)
        .to eq('labour market')
      expect(Newsmlg2::I18n.for_language(cm.subjects[1].names, 'de').text)
        .to eq('Arbeitsmarkt')
      expect(Newsmlg2::I18n.for_language(cm.subjects[1].names, 'klingon')).to be_nil

      expect(cm.genres.first.qcode).to eq('genre:interview')
      expect(cm.genres.first.names.first.text).to eq('Interview')
      expect(cm.genres.first.names[0].xml_lang).to eq('en-GB')
      expect(cm.sluglines.first.to_s).to eq('US-Finance-Fed')
      expect(cm.headlines.first.to_s).to eq('Fed to halt QE to avert "bubble"')

      expect(newsitem.content_set.inlinexml.first.contenttype).to eq('application/nitf+xml')
    end
  end

  describe 'LISTING_3 (photo)' do
    let(:doc) { Newsmlg2.parse_file('spec/fixtures/python/test_files/LISTING_3_Photo_in_NewsML-G2.xml') }
    let(:newsitem) { doc.item }

    it 'reads attributes and rights' do
      expect(newsitem.guid).to eq('tag:gettyimages.com,2010:GYI0062134533')
      expect(newsitem.version).to eq('11')
      expect(newsitem.xml_lang).to eq('en-US')
      rights = newsitem.rights_infos.first
      expect(rights.copyright_holder.uri).to eq('http://www.gettyimages.com')
      expect(rights.copyright_holder.names.first.text).to eq('Getty Images North America')
      expect(rights.copyright_notices.first.href)
        .to eq('http://www.gettyimages.com/Corporate/LicenseInfo.aspx')
      expect(rights.copyright_notices.first.to_s)
        .to include('Copyright 2010 Getty Images')
      expect(rights.usage_terms.first.to_s.gsub(/\s+/, ' '))
        .to include('Contact your local office for all commercial or promotional uses')
    end

    it 'reads contentMeta subjects, creditline and description' do
      cm = newsitem.content_meta
      expect(cm.creditlines.first.text).to eq('Getty Images')
      expect(cm.subjects[0].type).to eq('cpnat:event')
      expect(cm.subjects[0].qcode).to eq('gyimeid:104530187')
      expect(cm.subjects[1].type).to eq('cpnat:abstract')
      expect(cm.subjects[1].qcode).to eq('medtop:20000523')
      expect(cm.subjects[1].names[0].xml_lang).to eq('en-GB')
      expect(cm.subjects[1].names[0].text).to eq('labour market')
      expect(cm.subjects[1].names[1].xml_lang).to eq('de')
      expect(cm.subjects[1].names[1].text).to eq('Arbeitsmarkt')
      expect(cm.subjects[2].qcode).to eq('medtop:20000533')
      expect(cm.subjects[2].names[0].text).to eq('unemployment')
      expect(cm.subjects[2].names[1].text).to eq('Arbeitslosigkeit')
      expect(cm.subjects[3].type).to eq('cpnat:geoArea')
      expect(cm.subjects[3].names.first.text).to eq('Las Vegas Boulevard')
      expect(cm.subjects[4].qcode).to eq('gycon:89109')
      expect(cm.subjects[4].names.first.text).to eq('Las Vegas')
      expect(cm.subjects[4].broader[0].qcode).to eq('iso3166-1a2:US-NV')
      expect(cm.subjects[4].broader[0].names.first.text).to eq('Nevada')
      expect(cm.subjects[4].broader[1].qcode).to eq('iso3166-1a3:USA')
      expect(cm.subjects[4].broader[1].names.first.text).to eq('United States')

      expect(cm.keywords.map(&:text))
        .to eq(%w[business economic economy finance poor poverty gamble])
      expect(cm.headlines.first.to_s.gsub(/\s+/, ' ').strip)
        .to eq('Variety Of Recessionary Forces Leave Las Vegas Economy Scarred')
      expect(cm.descriptions.first.role).to eq('drol:caption')
      expect(cm.descriptions.first.to_s)
        .to include('A general view of part of downtown')
    end
  end

  describe 'programmatic creation' do
    it 'creates a simple news item in code' do
      newsitem = Newsmlg2::NewsItem.new(guid: 'test-guid', xml_lang: 'en-GB')
      doc = Newsmlg2::Document.new(newsitem)

      expect(doc.item.guid).to eq('test-guid')
      expect(newsitem.standard).to eq('NewsML-G2')
      expect(newsitem.standardversion).to eq('2.35')
      expect(newsitem.conformance).to eq('power')
      expect(newsitem.version).to eq('1')
      expect(newsitem.xml_lang).to eq('en-GB')
    end

    it 'serializes a simple news item to canonical XML' do
      newsitem = Newsmlg2::NewsItem.new(guid: 'test-guid', xml_lang: 'en-GB')
      expected = <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <newsItem xmlns="http://iptc.org/std/nar/2006-10-01/" xml:lang="en-GB" standard="NewsML-G2" standardversion="2.35" conformance="power" guid="test-guid" version="1"/>
      XML
      expect(Newsmlg2::Document.new(newsitem).to_xml).to eq(expected)
    end

    it 'creates a readme-style news item in code' do
      item_meta = Newsmlg2::ItemMeta.new(
        item_class: Newsmlg2::Types::QualRelPropType.new(qcode: 'ninat:text'),
        provider: Newsmlg2::Types::FlexPartyPropType.new(qcode: 'nprov:IPTC'),
        version_created: Newsmlg2::Types::DateTimePropType.new(text: '2020-06-22T12:00:00+03:00')
      )
      content_meta = Newsmlg2::ContentMeta.new(
        content_created: Newsmlg2::Types::TruncatedDateTimePropType.new(
          text: '2008-11-05T19:04:00-08:00'
        )
      )
      newsitem = Newsmlg2::NewsItem.new(
        guid: 'test-guid', xml_lang: 'en-GB',
        item_meta: item_meta, content_meta: content_meta
      )

      expected = <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <newsItem xmlns="http://iptc.org/std/nar/2006-10-01/" xml:lang="en-GB" standard="NewsML-G2" standardversion="2.35" conformance="power" guid="test-guid" version="1">
          <itemMeta>
            <itemClass qcode="ninat:text"/>
            <provider qcode="nprov:IPTC"/>
            <versionCreated>2020-06-22T12:00:00+03:00</versionCreated>
          </itemMeta>
          <contentMeta>
            <contentCreated>2008-11-05T19:04:00-08:00</contentCreated>
          </contentMeta>
        </newsItem>
      XML
      expect(Newsmlg2::Document.new(newsitem).to_xml).to eq(expected)
    end

    it 'creates a complex news item with located hierarchy, digitalSourceType and creator' do
      located = Newsmlg2::Types::FlexLocationPropType.new(
        type: 'cptype:city', qcode: 'city:345678',
        names: [Newsmlg2::Types::ConceptNameType.new(text: 'Berlin')],
        broader: [
          Newsmlg2::Types::Broader.new(
            type: 'cptype:statprov', qcode: 'state:2365',
            names: [Newsmlg2::Types::ConceptNameType.new(text: 'Berlin')]
          ),
          Newsmlg2::Types::Broader.new(
            type: 'cptype:country', qcode: 'iso3166-1a2:DE',
            names: [Newsmlg2::Types::ConceptNameType.new(text: 'Germany')]
          )
        ]
      )
      creator = Newsmlg2::Types::FlexAuthorPropType.new(
        qcode: 'codesource:DEZDF',
        names: [Newsmlg2::Types::ConceptNameType.new(text: 'Zweites Deutsches Fernsehen')],
        organisation_details: Newsmlg2::Types::OrganisationDetails.new(
          locations: [Newsmlg2::Types::OrganisationLocation.new(
            names: [Newsmlg2::Types::ConceptNameType.new(text: 'MAINZ')]
          )]
        )
      )
      content_meta = Newsmlg2::ContentMeta.new(
        content_created: Newsmlg2::Types::TruncatedDateTimePropType.new(
          text: '2008-11-05T19:04:00-08:00'
        ),
        located: [located],
        digital_source_type: Newsmlg2::Types::DigitalSourceType.new(
          uri: 'http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia'
        ),
        creators: [creator]
      )
      newsitem = Newsmlg2::NewsItem.new(
        guid: 'test-complex-newsitem-in-code-guid', xml_lang: 'en-GB',
        item_meta: Newsmlg2::ItemMeta.new(
          item_class: Newsmlg2::Types::QualRelPropType.new(qcode: 'ninat:video'),
          provider: Newsmlg2::Types::FlexPartyPropType.new(qcode: 'nprov:IPTC'),
          version_created: Newsmlg2::Types::DateTimePropType.new(
            text: '2020-06-22T12:00:00+03:00'
          )
        ),
        content_meta: content_meta
      )

      expect(content_meta.digital_source_type.uri)
        .to eq('http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia')
      expect(content_meta.located.first.names.first.text).to eq('Berlin')

      expected = <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <newsItem xmlns="http://iptc.org/std/nar/2006-10-01/" xml:lang="en-GB" standard="NewsML-G2" standardversion="2.35" conformance="power" guid="test-complex-newsitem-in-code-guid" version="1">
          <itemMeta>
            <itemClass qcode="ninat:video"/>
            <provider qcode="nprov:IPTC"/>
            <versionCreated>2020-06-22T12:00:00+03:00</versionCreated>
          </itemMeta>
          <contentMeta>
            <contentCreated>2008-11-05T19:04:00-08:00</contentCreated>
            <digitalSourceType uri="http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia"/>
            <located qcode="city:345678" type="cptype:city">
              <name>Berlin</name>
              <broader qcode="state:2365" type="cptype:statprov">
                <name>Berlin</name>
              </broader>
              <broader qcode="iso3166-1a2:DE" type="cptype:country">
                <name>Germany</name>
              </broader>
            </located>
            <creator qcode="codesource:DEZDF">
              <name>Zweites Deutsches Fernsehen</name>
              <organisationDetails>
                <location>
                  <name>MAINZ</name>
                </location>
              </organisationDetails>
            </creator>
          </contentMeta>
        </newsItem>
      XML
      expect(Newsmlg2::Document.new(newsitem).to_xml).to eq(expected)
    end

    it 'refuses to serialize an item without a guid' do
      doc = Newsmlg2::Document.new(Newsmlg2::NewsItem.new)
      expect { doc.to_xml }.to raise_error(Newsmlg2::MissingGuidError)
    end
  end

  describe 'embedded catalog' do
    let(:xml) do
      <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <newsItem
            xmlns="http://iptc.org/std/nar/2006-10-01/"
            guid="simplest-test"
            xml:lang="en-GB">
            <catalog>
                <title>Test embedded catalog</title>
                <scheme alias="foo" uri="http://example.org/foo/" authority="https://iptc.org/" modified="2023-07-17T12:00:00+00:00">
                    <name xml:lang="en-GB">foo scheme</name>
                    <definition xml:lang="en-GB">scheme "foo" for test</definition>
                </scheme>
                <scheme alias="bar" uri="http://example.org/bar/" authority="https://iptc.org/" modified="2023-07-17T12:00:00+00:00">
                    <name xml:lang="en-GB">bar scheme</name>
                    <definition xml:lang="en-GB">scheme "bar" for test</definition>
                </scheme>
            </catalog>
            <catalogRef href="http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_38.xml" />
            <itemMeta>
                <itemClass qcode="ninat:text" />
                <provider qcode="nprov:IPTC" />
                <versionCreated>2020-06-22T12:00:00+03:00</versionCreated>
            </itemMeta>
        </newsItem>
      XML
    end
    let(:doc) { Newsmlg2.parse(xml) }
    let(:newsitem) { doc.item }

    it 'registers inline catalogs and catalogRef catalogs' do
      expect(doc.catalog_store.length).to eq(2)

      nprov = doc.catalog_store.get_scheme_for_alias('nprov')
      expect(nprov.uri).to eq('http://cv.iptc.org/newscodes/newsprovider/')
      expect(nprov.authority).to eq('https://iptc.org/')

      foo = doc.catalog_store.get_scheme_for_alias('foo')
      expect(foo.uri).to eq('http://example.org/foo/')
      expect(foo.definitions.first.to_s).to eq('scheme "foo" for test')
      expect(foo.to_s).to eq('foo scheme (foo, http://example.org/foo/)')

      by_uri = doc.catalog_store.get_scheme_for_uri('http://example.org/foo/')
      expect(by_uri.alias_attr).to eq('foo')

      expect { doc.catalog_store.get_scheme_for_uri('http://example.org/nonexistent/') }
        .to raise_error(Newsmlg2::UriNotFoundInCatalogs)

      expect(doc.catalog_store[0]).to be_a(Newsmlg2::Catalog)
      expect(doc.catalog_store[0].to_s).to eq('<Catalog "Test embedded catalog">')
      expect(doc.catalog_store[0].length).to eq(2)
      expect(doc.catalog_store[1]).to be_a(Newsmlg2::Catalog)
    end

    it 'supports replacing and deleting schemes in the inline catalog' do
      newscheme = Newsmlg2::Scheme.new(
        alias_attr: 'baz', uri: 'http://example.org/baz/',
        modified: '2023-07-21T12:00:00+00:00',
        names: [Newsmlg2::Types::ConceptNameType.new(text: 'baz scheme')]
      )

      catalog = newsitem.catalogs.first
      catalog.schemes[1] = newscheme
      expect(catalog.schemes.length).to eq(2)
      expect(catalog.schemes[0].alias_attr).to eq('foo')
      expect(catalog.schemes[1].alias_attr).to eq('baz')

      catalog.schemes.delete_at(0)
      expect(catalog.schemes.length).to eq(1)
      expect(catalog.schemes[0].alias_attr).to eq('baz')
    end
  end
end
