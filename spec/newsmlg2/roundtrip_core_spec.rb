# frozen_string_literal: true

# Port of python-newsmlg2 tests/test_roundtrip.py, test_core.py and
# test_autoloader.py.
#
# Byte-for-byte equality with python's lxml output format is replaced by
# (a) idempotence of our canonical output and (b) canon semantic equivalence
# with the source document — our serializer emits the same canonical form on
# every pass.
require 'spec_helper'
require_relative '../support/xml_order_normalizer'

RSpec.describe 'python test_roundtrip / test_core / test_autoloader' do
  describe 'roundtrip' do
    it 'is idempotent and semantically faithful for fixture 008' do
      source = File.read('spec/fixtures/python/test_files/008_roundtrip_test.xml')
      doc = Newsmlg2.parse(source)
      once = doc.to_xml
      twice = Newsmlg2.parse(once).to_xml
      expect(twice).to eq(once)
      expect("<r>#{Newsmlg2.parse(once).to_xml}</r>")
        .to be_xml_equivalent_to("<r>#{once}</r>")
      expect(XmlOrderNormalizer.normalize(once))
        .to be_xml_equivalent_to(XmlOrderNormalizer.normalize(source))
    end

    it 'round-trips all vendored python fixtures without information loss' do
      Dir['spec/fixtures/python/test_files/*.xml'].each do |path|
        source = File.read(path)
        once = Newsmlg2.parse(source).to_xml
        expect(Newsmlg2.parse(once).to_xml).to eq(once), "not idempotent: #{path}"

        # Our serializer adds the spec's default attributes (standard,
        # standardversion, conformance, version) like python-newsmlg2 does;
        # drop the ones the source did not carry so the comparison checks
        # for information loss, not for additive defaults. Only the document
        # body is rewritten so the XML declaration's version is untouched.
        decl, body = once.split('?>', 2)
        _sdecl, source_body = source.split('?>', 2)
        source_body ||= source
        %w[standard standardversion conformance version].each do |attr|
          next if source_body =~ /\s#{attr}="/

          body = body.gsub(/ #{attr}="[^"]*"/, '')
        end
        lossless = [decl, body].join('?>')
        expect(XmlOrderNormalizer.normalize(lossless))
          .to be_xml_equivalent_to(XmlOrderNormalizer.normalize(source)),
              "semantic drift: #{path}"
      end
    end
  end

  describe 'core error cases' do
    it 'rejects non-NewsML-G2 root elements' do
      expect { Newsmlg2.parse('<foo/>') }
        .to raise_error(Newsmlg2::UnknownRootElement, /foo/)
    end

    it 'rejects non-item assignment' do
      expect { Newsmlg2::Document.new.item = 42 }.to raise_error(ArgumentError)
    end
  end

  describe 'autoloaded API surface (python import_string test)' do
    it 'resolves every public class without explicit requires' do
      %w[
        NewsItem PackageItem ConceptItem KnowledgeItem CatalogItem
        PlanningItem NewsMessage ItemMeta ContentMeta PartMeta AnyItem
        Document CatalogStore Catalog CatalogRef Scheme
        Group GroupSet ItemRef Planning NewsCoverage NewsCoverageSet
      ].each do |name|
        expect(Newsmlg2.const_get(name)).to be_a(Class), "cannot resolve #{name}"
      end
      expect { Newsmlg2.const_get(:NoSuchClass) }.to raise_error(NameError)
    end
  end
end
