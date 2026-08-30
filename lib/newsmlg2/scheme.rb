# frozen_string_literal: true

module Newsmlg2
  # A scheme alias-to-URI mapping, as declared inside a catalog.
  class Scheme < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::AuthorityAttributes

    xml_attributes :schemecreated, :schememodified, :schemeretired,
                   alias_attr: 'alias', uri: 'uri'
    xml_element :same_as_schemes, xml: 'sameAsScheme',
                                  type: Newsmlg2::SameAsScheme, collection: true
    xml_element :names, xml: 'name',
                        type: Newsmlg2::Types::ConceptNameType, collection: true
    xml_element :definitions, xml: 'definition',
                              type: Newsmlg2::Types::Definition, collection: true
    xml_element :notes, xml: 'note',
                        type: Newsmlg2::Types::Note, collection: true
    xml_element :same_as, xml: 'sameAs',
                          type: Newsmlg2::Types::SameAs, collection: true

    xml do
      element 'scheme'
    end

    def to_s
      "#{names.first} (#{alias_attr}, #{uri})"
    end
  end
end
