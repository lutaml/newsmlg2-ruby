# frozen_string_literal: true

module Newsmlg2
  module Types
    # The preferred unambiguous identifier for a concept.
    class ConceptIdType < QCodePropType
      xml_attributes :created, :retired
    end

    # Serialized as the "conceptId" element.
    class ConceptId < ConceptIdType
      xml do
        element 'conceptId'
      end
    end
  end
end
