# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Newsmlg2::CatalogStore do
  let(:catalog40_url) { 'http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_40.xml' }

  describe Newsmlg2::CatalogCache do
    it 'resolves IPTC standard catalog URLs to bundled files' do
      expect(Newsmlg2::CatalogCache.bundled_path_for(catalog40_url))
        .to end_with('catalog.IPTC-G2-Standards_40.xml')
      expect(Newsmlg2::CatalogCache.read(catalog40_url)).to include('<catalog')
    end

    it 'returns nil for unknown URLs' do
      expect(Newsmlg2::CatalogCache.read('http://example.test/catalog.xml')).to be_nil
      expect(Newsmlg2::CatalogCache.read(
               "http://evil.test/#{File.basename(catalog40_url)}"
             )).to be_nil
    end

    it 'parses each bundled catalog once, sharing the result' do
      expect(Newsmlg2::CatalogCache.load(catalog40_url))
        .to equal(Newsmlg2::CatalogCache.load(catalog40_url))
    end
  end

  describe 'bundled catalog parsing' do
    let(:catalog) { Newsmlg2::CatalogCache.load(catalog40_url) }

    it 'parses schemes with alias and uri' do
      expect(catalog).to be_a(Newsmlg2::Catalog)
      expect(catalog.schemes).not_to be_empty
      ninat = catalog.get_scheme_for_alias('ninat')
      expect(ninat.uri).to eq('http://cv.iptc.org/newscodes/ninature/')
      expect(catalog.get_scheme_for_uri('http://cv.iptc.org/newscodes/ninature/').alias_attr)
        .to eq('ninat')
    end

    it 'round-trips the bundled catalog semantically' do
      original = Newsmlg2::CatalogCache.read(catalog40_url)
      expect("<r>#{catalog.to_xml}</r>").to be_xml_equivalent_to("<r>#{original}</r>")
    end
  end

  describe 'store lookups' do
    let(:store) do
      Newsmlg2::CatalogStore.new.tap do |s|
        s.add_catalog(Newsmlg2::CatalogCache.load(catalog40_url))
      end
    end

    it 'finds schemes by alias and URI across catalogs' do
      expect(store.get_scheme_for_alias('nprov').uri)
        .to eq('http://cv.iptc.org/newscodes/newsprovider/')
      expect(store.get_scheme_for_uri('http://cv.iptc.org/newscodes/newsprovider/').alias_attr)
        .to eq('nprov')
    end

    it 'raises for unknown alias and URI' do
      expect { store.get_scheme_for_alias('nosuch') }
        .to raise_error(Newsmlg2::AliasNotFoundInCatalogs, /nosuch/)
      expect { store.get_scheme_for_uri('http://example.test/') }
        .to raise_error(Newsmlg2::UriNotFoundInCatalogs)
    end

    it 'supports qcode <-> uri conversion' do
      expect(store.qcode_to_uri('ninat:text'))
        .to eq('http://cv.iptc.org/newscodes/ninature/text')
      expect(store.uri_to_qcode('http://cv.iptc.org/newscodes/ninature/text'))
        .to eq('ninat:text')
      expect(Newsmlg2.qcode_to_uri('ninat:text', store))
        .to eq('http://cv.iptc.org/newscodes/ninature/text')
      expect(Newsmlg2.uri_to_qcode('http://cv.iptc.org/newscodes/ninature/text', store))
        .to eq('ninat:text')
    end

    it 'rejects values that are not qcodes or concept URIs' do
      expect { store.qcode_to_uri('no-colon') }
        .to raise_error(ArgumentError, /not a qcode/)
      expect { store.uri_to_qcode('no-slash') }
        .to raise_error(ArgumentError, /not a concept URI/)
    end
  end

  describe 'inline catalog parsing' do
    let(:xml) do
      '<catalog xmlns="http://iptc.org/std/nar/2006-10-01/" ' \
        'additionalInfo="http://example.test/info">' \
        '<title>IPTC Scheme catalog</title>' \
        '<scheme alias="nrol" uri="http://cv.iptc.org/newscodes/namerole/">' \
        '<name xml:lang="en">Name Role</name>' \
        '<definition xml:lang="en">Role of a name</definition>' \
        '</scheme></catalog>'
    end

    it 'parses title, schemes and their children' do
      catalog = Newsmlg2::Catalog.from_xml(xml)
      expect(catalog.additionalinfo).to eq('http://example.test/info')
      expect(catalog.titles.first.text.join).to include('IPTC Scheme catalog')
      scheme = catalog.get_scheme_for_alias('nrol')
      expect(scheme.uri).to eq('http://cv.iptc.org/newscodes/namerole/')
      expect(scheme.names.first.text).to eq('Name Role')
      expect(scheme.definitions.first.text.join).to include('Role of a name')
    end

    it 'round-trips an inline catalog' do
      catalog = Newsmlg2::Catalog.from_xml(xml)
      expect("<r>#{catalog.to_xml}</r>").to be_xml_equivalent_to("<r>#{xml}</r>")
    end
  end

  describe Newsmlg2::CatalogRef do
    it 'parses href and title' do
      ref = Newsmlg2::CatalogRef.from_xml(
        '<catalogRef xmlns="http://iptc.org/std/nar/2006-10-01/" ' \
        'href="http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_40.xml" ' \
        'title="IPTC Business Event catalog"/>'
      )
      expect(ref.href).to eq('http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_40.xml')
      expect(ref.title).to eq('IPTC Business Event catalog')
      expect(ref.to_xml).to include('href="http://www.iptc.org')
    end
  end
end
