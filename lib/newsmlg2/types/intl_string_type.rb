# frozen_string_literal: true

module Newsmlg2
  module Types
    # Internationalized normalized string: content plus language/directionality.
    class IntlStringType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::I18NAttributes

      xml_content

      def to_s
        text.to_s.strip
      end
    end
  end
end
