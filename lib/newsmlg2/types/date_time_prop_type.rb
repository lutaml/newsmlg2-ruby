# frozen_string_literal: true

module Newsmlg2
  module Types
    # Property carrying an xsd:dateTime as element content.
    class DateTimePropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_content
    end
  end
end
