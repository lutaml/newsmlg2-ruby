# frozen_string_literal: true

module Newsmlg2
  # An Item containing information about a concept.
  class ConceptItem < AnyItem
    xml_element :content_meta, xml: 'contentMeta',
                               type: Newsmlg2::ContentMetaAcD
    xml_element :asserts, xml: 'assert',
                          type: Newsmlg2::Assert, collection: true
    xml_element :inline_refs, xml: 'inlineRef',
                              type: Newsmlg2::InlineRef, collection: true
    xml_element :derived_from, xml: 'derivedFrom',
                               type: Newsmlg2::DerivedFrom, collection: true
    xml_element :derived_from_values, xml: 'derivedFromValue',
                                      type: Newsmlg2::DerivedFromValue, collection: true
    xml_element :concept, xml: 'concept',
                          type: Newsmlg2::Types::Concept

    xml do
      element 'conceptItem'
    end
  end
end
