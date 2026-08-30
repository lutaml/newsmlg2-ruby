# frozen_string_literal: true

module Newsmlg2
  module Types
    # A set of properties defining a concept.
    class Concept < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::I18NAttributes

      xml_element :concept_id, xml: 'conceptId',
                               type: Newsmlg2::Types::ConceptId
      xml_element :type, xml: 'type', type: Newsmlg2::Types::ConceptType
      xml_element :names, xml: 'name',
                          type: Newsmlg2::Types::ConceptNameType, collection: true
      xml_element :definitions, xml: 'definition',
                                type: Newsmlg2::Types::Definition, collection: true
      xml_element :notes, xml: 'note',
                          type: Newsmlg2::Types::Note, collection: true
      xml_element :facets, xml: 'facet',
                           type: Newsmlg2::Types::Facet, collection: true
      xml_element :remote_infos, xml: 'remoteInfo',
                                 type: Newsmlg2::Types::RemoteInfo, collection: true
      xml_element :hierarchy_infos, xml: 'hierarchyInfo',
                                    type: Newsmlg2::Types::HierarchyInfo, collection: true
      include Newsmlg2::Base::ConceptRelationshipsGroup
      include Newsmlg2::Base::EntityDetailsGroup

      xml_element :concept_ext_property, xml: 'conceptExtProperty',
                                         type: Newsmlg2::Types::Flex2ExtPropType

      xml do
        element 'concept'
      end
    end
  end
end
