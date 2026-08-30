# frozen_string_literal: true

module Newsmlg2
  module Types
    # Internationalized unrestricted string: content plus
    # language/directionality.
    class IntlStringType2 < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::I18NAttributes

      xml_content
    end
  end
end
