# frozen_string_literal: true

module Newsmlg2
  module Types
    # A generic mechanism for adding inline information to parts of textual
    # content. Mixed content.
    class Span < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::I18NAttributes

      xml_attributes class_attr: 'class'
      xml_element :rubies, xml: 'ruby', type: Newsmlg2::Types::Ruby, collection: true

      xml_content(collection: true)

      xml do
        element 'span'
      end
    end

    # An inline markup tag usable with any concept. Mixed content.
    class Inline < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::FlexAttributes
      include Newsmlg2::Base::I18NAttributes
      include Newsmlg2::Base::QuantifyAttributes

      xml_attributes class_attr: 'class'
      xml_element :spans, xml: 'span', type: Newsmlg2::Types::Span, collection: true
      xml_element :rubies, xml: 'ruby', type: Newsmlg2::Types::Ruby, collection: true

      xml_content(collection: true)

      xml do
        element 'inline'
      end
    end

    # An anchor for inline linking, like the HTML a element. Mixed content.
    class A < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::I18NAttributes

      xml_attributes :href, :hreflang, :rel, :rev, class_attr: 'class'
      xml_element :inlines, xml: 'inline', type: Newsmlg2::Types::Inline, collection: true
      xml_element :spans, xml: 'span', type: Newsmlg2::Types::Span, collection: true
      xml_element :rubies, xml: 'ruby', type: Newsmlg2::Types::Ruby, collection: true

      xml_content(collection: true)

      xml do
        element 'a'
      end
    end
  end
end
