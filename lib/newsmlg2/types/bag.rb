# frozen_string_literal: true

module Newsmlg2
  module Types
    # A group of existing concepts which express a new concept.
    class Bag < QCodePropType
      include Newsmlg2::Base::QuantifyAttributes

      xml_attributes :type, :typeuri, :significance

      xml do
        element 'bag'
      end
    end
  end
end
