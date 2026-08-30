# frozen_string_literal: true

module Newsmlg2
  module Base
    # A group of properties required to define a concept (concepts.py).
    module ConceptDefinitionGroup
      def self.included(klass)
        klass.class_eval do
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
        end
      end
    end
  end
end
