# frozen_string_literal: true

module Newsmlg2
  module Types
    # Property carrying a possibly truncated date-time as content
    # (xs:date | xs:dateTime | xs:gYearMonth | xs:gYear).
    class TruncatedDateTimePropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_content
    end
  end
end
