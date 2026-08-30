# frozen_string_literal: true

module Newsmlg2
  module Types
    # Property carrying an approximate date-time as content, with an optional
    # approximation range.
    class ApproximateDateTimePropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :approxstart, :approxend
      xml_content
    end
  end
end
