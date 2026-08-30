# frozen_string_literal: true

module Newsmlg2
  module Types
    # The type for an identifier of a related concept.
    #
    # NOTE: the :related child is declared at the bottom of this file (after
    # Related exists) because Related's inheritance chain passes through
    # RelatedConceptType — an eager reference here would be a circular
    # autoload.
    class RelatedConceptType < FlexPropType
      include Newsmlg2::Base::TimeValidityAttributes

      xml_attributes :rel, :reluri, :rank

      xml_element :facets, xml: 'facet',
                           type: Newsmlg2::Types::Facet, collection: true
    end

    # The concept which is faceted by other concept(s) asserted by
    # facetConcept.
    class MainConcept < RelatedConceptType
      xml do
        element 'mainConcept'
      end
    end

    # The concept which is faceting another concept asserted by mainConcept.
    class FacetConcept < RelatedConceptType
      xml do
        element 'facetConcept'
      end
    end

    # An identifier of a more generic concept.
    class Broader < RelatedConceptType
      xml do
        element 'broader'
      end
    end

    # An identifier of a more specific concept.
    class Narrower < RelatedConceptType
      xml do
        element 'narrower'
      end
    end

    # The type for identifying a related concept.
    class FlexRelatedConceptType < RelatedConceptType
      include Newsmlg2::Base::ArbitraryValueAttributes

      xml_element :bag, type: Newsmlg2::Types::Bag
    end

    # A related concept, where the relationship is different from 'sameAs',
    # 'broader' or 'narrower'.
    class Related < FlexRelatedConceptType
      xml do
        element 'related'
      end
    end

    class RelatedConceptType
      xml_element :related, xml: 'related',
                            type: Newsmlg2::Types::Related, collection: true
      xml_element :same_as, xml: 'sameAs',
                            type: Newsmlg2::Types::SameAs, collection: true
    end
  end
end
