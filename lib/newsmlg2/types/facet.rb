# frozen_string_literal: true

module Newsmlg2
  module Types
    # An intrinsic property of a concept (deprecated since NAR 1.8; use
    # "related" instead).
    class Facet < FlexPropType
      include Newsmlg2::Base::TimeValidityAttributes

      xml_attributes :rel, :reluri, :g2flag

      xml do
        element 'facet'
      end
    end
  end
end
