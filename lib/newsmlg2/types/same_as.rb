# frozen_string_literal: true

module Newsmlg2
  module Types
    # An identifier of a concept with equivalent semantics.
    class SameAsType < FlexPropType
      include Newsmlg2::Base::TimeValidityAttributes
    end

    # Serialized as the "sameAs" element.
    class SameAs < SameAsType
      xml do
        element 'sameAs'
      end
    end
  end
end
