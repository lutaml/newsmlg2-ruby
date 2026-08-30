# frozen_string_literal: true

module Newsmlg2
  module Types
    # A property with a QCode value in its qcode attribute, a URI in its uri
    # attribute and optional names.
    class QualPropType < QCodePropType
      include Newsmlg2::Base::I18NAttributes

      xml_element :names, xml: 'name',
                          type: Newsmlg2::Types::ConceptNameType, collection: true
      xml_element :hierarchy_infos, xml: 'hierarchyInfo',
                                    type: Newsmlg2::Types::HierarchyInfo, collection: true
    end

    # The nature of a concept (python-newsmlg2 calls this class "Type").
    class ConceptType < QualPropType
      xml do
        element 'type'
      end
    end
  end
end
