# frozen_string_literal: true

require_relative 'xml_order_normalizer'

# Spec support: the shared round-trip assertions used by the python-suite
# port and the IPTC compliance specs.
module RoundtripHelper
  DEFAULT_ATTRS = %w[standard standardversion conformance version].freeze

  def expect_idempotent_roundtrip(xml)
    once = Newsmlg2.parse(xml).to_xml
    twice = Newsmlg2.parse(once).to_xml
    # Semantic idempotence: the canonical form is stable up to namespace
    # declaration order (byte-stability is asserted in the python-suite
    # port).
    expect(XmlOrderNormalizer.normalize(twice))
      .to be_xml_equivalent_to(XmlOrderNormalizer.normalize(once))
    once
  end

  def expect_no_information_loss(once, source)
    # Drop the spec default attributes our serializer adds (as
    # python-newsmlg2 does) when the source did not carry them, then check
    # semantic equivalence (order- and whitespace-insensitive).
    decl, body = once.split('?>', 2)
    _sdecl, source_body = source.split('?>', 2)
    source_body ||= source
    DEFAULT_ATTRS.each do |attr|
      next if source_body =~ /\s#{attr}="/

      body = body.gsub(/ #{attr}="[^"]*"/, '')
    end
    lossless = [decl, body].join('?>')
    expect(XmlOrderNormalizer.normalize(lossless))
      .to be_xml_equivalent_to(XmlOrderNormalizer.normalize(source))
  end
end
