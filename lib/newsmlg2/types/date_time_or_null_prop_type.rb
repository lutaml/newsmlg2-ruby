# frozen_string_literal: true

module Newsmlg2
  module Types
    # Property carrying a date-time or an empty string as content.
    class DateTimeOrNullPropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_content
    end
  end
end
