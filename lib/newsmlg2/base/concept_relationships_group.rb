# frozen_string_literal: true

module Newsmlg2
  module Base
    # A group of properties expressing relationships between concepts
    # (conceptrelationships.py).
    module ConceptRelationshipsGroup
      def self.included(klass)
        klass.class_eval do
          xml_element :same_as, xml: 'sameAs',
                                type: Newsmlg2::Types::SameAs, collection: true
          xml_element :broader, xml: 'broader',
                                type: Newsmlg2::Types::Broader, collection: true
          xml_element :narrower, xml: 'narrower',
                                 type: Newsmlg2::Types::Narrower, collection: true
          xml_element :related, xml: 'related',
                                type: Newsmlg2::Types::Related, collection: true
        end
      end
    end
  end
end
