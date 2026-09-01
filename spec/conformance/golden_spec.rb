# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/xml_order_normalizer'

# Cross-implementation conformance: the shared golden documents must parse
# and round-trip cleanly here — the TypeScript codec runs the mirror suite.
# Fixtures live in the newsmlg2-fixtures repository (NEWSMLG2_FIXTURES or a
# sibling checkout); the suite skips silently when they are absent so
# casual checkouts still pass.
RSpec.describe 'newsmlg2-fixtures goldens' do
  let(:fixtures) do
    candidates = [ENV.fetch('NEWSMLG2_FIXTURES', nil),
                  File.expand_path('../../../newsmlg2-fixtures', __dir__)].compact
    golden_dirs = candidates.map { |path| File.join(path, 'golden') }
    golden_dirs.find { |dir| File.directory?(dir) }
  end

  it 'parses every golden document without errors' do
    skip 'newsmlg2-fixtures not present' unless fixtures

    files = Dir[File.join(fixtures, '*.xml')]
    expect(files).not_to be_empty
    files.each do |file|
      doc = Newsmlg2.parse(File.read(file))
      expect(doc.item).not_to be_nil, file
    end
  end

  it 'round-trips every golden document semantically' do
    skip 'newsmlg2-fixtures not present' unless fixtures

    Dir[File.join(fixtures, '*.xml')].each do |file|
      source = File.read(file)
      _decl, body = Newsmlg2.parse(source).to_xml.split('?>', 2)
      _sdecl, source_body = source.split('?>', 2)
      expected = XmlOrderNormalizer.normalize(source_body || source)
      expect(XmlOrderNormalizer.normalize(body))
        .to(be_xml_equivalent_to(expected), file)
    end
  end
end
