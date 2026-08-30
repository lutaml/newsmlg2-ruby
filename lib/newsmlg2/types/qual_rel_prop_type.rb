# frozen_string_literal: true

module Newsmlg2
  module Types
    # A property with a QCode value in its qcode attribute, a URI in its uri
    # attribute and optional names and related concepts.
    class QualRelPropType < QCodePropType
      include Newsmlg2::Base::I18NAttributes

      xml_element :names, xml: 'name',
                          type: Newsmlg2::Types::ConceptNameType, collection: true
      xml_element :hierarchy_infos, xml: 'hierarchyInfo',
                                    type: Newsmlg2::Types::HierarchyInfo, collection: true
      xml_element :related, xml: 'related',
                            type: Newsmlg2::Types::Related, collection: true
    end
  end
end
