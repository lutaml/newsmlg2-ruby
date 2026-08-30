# frozen_string_literal: true

module Newsmlg2
  module Types
    # A line break inside block content.
    class Br < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml do
        element 'br'
      end
    end

    # Ruby base text.
    class Rb < Newsmlg2::NarModel
      xml_content

      xml do
        element 'rb'
      end
    end

    # Ruby parenthesis.
    class Rp < Newsmlg2::NarModel
      xml_content

      xml do
        element 'rp'
      end
    end

    # Ruby text.
    class Rt < Newsmlg2::NarModel
      xml_content

      xml do
        element 'rt'
      end
    end

    # Simple W3C Ruby Annotation (http://www.w3.org/TR/ruby/#simple-ruby1).
    class Ruby < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::I18NAttributes

      xml_element :rb, type: Newsmlg2::Types::Rb
      xml_element :rt, type: Newsmlg2::Types::Rt
      xml_element :rp, type: Newsmlg2::Types::Rp

      xml do
        element 'ruby'
      end
    end
  end
end
