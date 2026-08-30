# frozen_string_literal: true

module Newsmlg2
  module Types
    # Property with a QCode value in its qcode attribute.
    class QCodePropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :qcode, :uri
    end
  end
end
