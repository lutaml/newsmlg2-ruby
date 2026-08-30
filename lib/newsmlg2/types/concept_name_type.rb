# frozen_string_literal: true

module Newsmlg2
  module Types
    # A natural-language name of a concept, with validity period and
    # role/part refinements. Serialized as the "name" element.
    class ConceptNameType < IntlStringType
      include Newsmlg2::Base::TimeValidityAttributes

      xml_attributes :role, :roleuri, :part, :parturi

      xml do
        element 'name'
      end
    end
  end
end
