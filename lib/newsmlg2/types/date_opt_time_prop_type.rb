# frozen_string_literal: true

module Newsmlg2
  module Types
    # Property carrying a date with an optional time part as content.
    class DateOptTimePropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_content
    end
  end
end
