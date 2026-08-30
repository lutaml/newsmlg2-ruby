# frozen_string_literal: true

module Newsmlg2
  module Types
    # Flexible generic PCL-type for both controlled and uncontrolled values,
    # carrying a full concept definition and concept relationships.
    class Flex1PropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::FlexAttributes
      include Newsmlg2::Base::I18NAttributes
      include Newsmlg2::Base::ConceptDefinitionGroup
      include Newsmlg2::Base::ConceptRelationshipsGroup
    end

    # Flex1PropType with a role refinement.
    class Flex1RolePropType < Flex1PropType
      xml_attributes :role, :roleuri
    end

    # Flexible generic PCL-type for controlled and uncontrolled values, with
    # optional quantifiers and faceted-concept children.
    class Flex1ConceptPropType < Flex1PropType
      include Newsmlg2::Base::QuantifyAttributes

      xml_element :bag, type: Newsmlg2::Types::Bag
      xml_element :main_concept, xml: 'mainConcept',
                                 type: Newsmlg2::Types::MainConcept
      xml_element :facet_concepts, xml: 'facetConcept',
                                   type: Newsmlg2::Types::FacetConcept, collection: true
    end
  end
end
