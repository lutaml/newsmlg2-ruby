# frozen_string_literal: true

module Newsmlg2
  module Types
    # Flexible type for related concepts for both controlled and
    # uncontrolled values.
    class FlexProp2Type < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::FlexAttributes
      include Newsmlg2::Base::I18NAttributes

      xml_element :names, xml: 'name',
                          type: Newsmlg2::Types::ConceptNameType, collection: true
      xml_element :hierarchy_infos, xml: 'hierarchyInfo',
                                    type: Newsmlg2::Types::HierarchyInfo, collection: true
      xml_element :same_as, xml: 'sameAs',
                            type: Newsmlg2::Types::SameAs, collection: true
    end

    # Flexible generic type for controlled and uncontrolled values of a
    # related concept.
    class FlexRelatedPropType < FlexProp2Type
      xml_attributes :rel, :reluri
    end
  end
end
