# frozen_string_literal: true

module Newsmlg2
  module Types
    # The PCL-type for information about the content as a natural language
    # string with minimal markup. Mixed content.
    class Label1Type < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::I18NAttributes

      xml_attributes :role, :roleuri, :media
      xml_element :anchors, xml: 'a', type: Newsmlg2::Types::A, collection: true
      xml_element :spans, xml: 'span', type: Newsmlg2::Types::Span, collection: true
      xml_element :rubies, xml: 'ruby', type: Newsmlg2::Types::Ruby, collection: true
      xml_element :inlines, xml: 'inline', type: Newsmlg2::Types::Inline, collection: true

      xml_content(collection: true)

      def to_s
        Array(text).join.strip
      end
    end

    # Natural-language content with minimal markup and line breaks.
    # Mixed content.
    class BlockType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::I18NAttributes

      xml_attributes :media, :role, :roleuri
      xml_element :anchors, xml: 'a', type: Newsmlg2::Types::A, collection: true
      xml_element :spans, xml: 'span', type: Newsmlg2::Types::Span, collection: true
      xml_element :rubies, xml: 'ruby', type: Newsmlg2::Types::Ruby, collection: true
      xml_element :brs, xml: 'br', type: Newsmlg2::Types::Br, collection: true
      xml_element :inlines, xml: 'inline', type: Newsmlg2::Types::Inline, collection: true

      xml_content(collection: true)

      def to_s
        Array(text).join.strip
      end
    end

    # A natural language definition of the semantics of a concept.
    class Definition < BlockType
      include Newsmlg2::Base::TimeValidityAttributes

      xml do
        element 'definition'
      end
    end

    # Additional natural language information about a concept.
    class Note < BlockType
      include Newsmlg2::Base::TimeValidityAttributes

      xml do
        element 'note'
      end
    end
  end
end
