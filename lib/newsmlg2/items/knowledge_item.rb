# frozen_string_literal: true

module Newsmlg2
  # An unordered set of concepts.
  class ConceptSet < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_element :concepts, xml: 'concept',
                           type: Newsmlg2::Types::Concept, collection: true

    xml do
      element 'conceptSet'
    end
  end

  # Metadata about a scheme conveyed by a Knowledge Item.
  class SchemeMeta < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::AuthorityAttributes

    xml_element :same_as_schemes, xml: 'sameAsScheme',
                                  type: Newsmlg2::SameAsScheme, collection: true
    xml_element :names, xml: 'name',
                        type: Newsmlg2::Types::ConceptNameType, collection: true
    xml_element :definitions, xml: 'definition',
                              type: Newsmlg2::Types::Definition, collection: true
    xml_element :notes, xml: 'note',
                        type: Newsmlg2::Types::Note, collection: true
    xml_element :related, xml: 'related',
                          type: Newsmlg2::Types::Related, collection: true
    xml_element :scheme_meta_ext_properties, xml: 'schemeMetaExtProperty',
                                             type: Newsmlg2::Types::Flex2ExtPropType, collection: true

    xml_attributes(
      :uri, :preferredalias, :concepttype,
      :schemecreated, :schememodified, :schemeretired
    )

    xml do
      element 'schemeMeta'
    end
  end

  # An Item used for collating a set of concept definitions to form the
  # physical representation of a controlled vocabulary.
  class KnowledgeItem < AnyItem
    xml_element :content_meta, xml: 'contentMeta',
                               type: Newsmlg2::ContentMetaAcD
    xml_element :part_metas, xml: 'partMeta',
                             type: Newsmlg2::PartMeta, collection: true
    xml_element :asserts, xml: 'assert',
                          type: Newsmlg2::Assert, collection: true
    xml_element :inline_refs, xml: 'inlineRef',
                              type: Newsmlg2::InlineRef, collection: true
    xml_element :derived_from, xml: 'derivedFrom',
                               type: Newsmlg2::DerivedFrom, collection: true
    xml_element :derived_from_values, xml: 'derivedFromValue',
                                      type: Newsmlg2::DerivedFromValue, collection: true
    xml_element :concept_set, xml: 'conceptSet',
                              type: Newsmlg2::ConceptSet
    xml_element :scheme_meta, xml: 'schemeMeta',
                              type: Newsmlg2::SchemeMeta

    xml do
      element 'knowledgeItem'
    end
  end
end
