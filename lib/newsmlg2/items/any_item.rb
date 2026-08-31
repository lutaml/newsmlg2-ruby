# frozen_string_literal: true

module Newsmlg2
  # An action which is executed at this hop in the hop history.
  class Action < Newsmlg2::Types::QualRelPropType
    xml_attributes :target, :targeturi, :timestamp

    xml do
      element 'action'
    end
  end

  # A single hop of the Hop History.
  class Hop < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_attributes :seq, :timestamp

    xml_element :parties, xml: 'party',
                          type: Newsmlg2::Types::Party, collection: true
    xml_element :actions, xml: 'action',
                          type: Newsmlg2::Action, collection: true

    xml do
      element 'hop'
    end
  end

  # A history of the creation and modifications of the content object of
  # this item, expressed as a sequence of hops.
  class HopHistory < Newsmlg2::NarModel
    xml_element :hops, xml: 'hop', type: Newsmlg2::Hop, collection: true

    xml do
      element 'hopHistory'
    end
  end

  # Time stamp representing an optionally truncated date and time.
  class Timestamp < Newsmlg2::Types::TruncatedDateTimePropType
    xml do
      element 'timestamp'
    end
  end

  # A step in the pubHistory.
  class Published < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_attributes :qcode, :uri, :literal

    xml_element :timestamp, xml: 'timestamp',
                            type: Newsmlg2::Timestamp
    xml_element :names, xml: 'name',
                        type: Newsmlg2::Types::ConceptNameType, collection: true
    xml_element :related, xml: 'related',
                          type: Newsmlg2::Types::Related, collection: true
    xml_element :published_ext_properties, xml: 'publishedExtProperty',
                                           type: Newsmlg2::Types::Flex2ExtPropType, collection: true

    xml do
      element 'published'
    end
  end

  # One to many datasets about publishing this item.
  class PubHistory < Newsmlg2::NarModel
    xml_element :published, xml: 'published',
                            type: Newsmlg2::Published, collection: true

    xml do
      element 'pubHistory'
    end
  end

  # An assertion about a concept. XSD AssertType carries xs:any ##any
  # content — NAR-namespace properties (name, geoAreaDetails, …) or
  # provider extensions — preserved verbatim in #content.
  class Assert < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::I18NAttributes

    xml_attributes :qcode, :uri, :literal

    attribute :content, :string

    xml do
      element 'assert'
      map_all to: :content
    end
  end

  # Inline reference: the concept represented by the content identified by
  # the local identifier(s).
  class InlineRef < Newsmlg2::Types::Flex1PropType
    include Newsmlg2::Base::QuantifyAttributes

    xml_attributes :idrefs

    xml do
      element 'inlineRef'
    end
  end

  # Refers to the ids of elements whose values have been derived from the
  # concept represented by this property.
  class DerivedFrom < Newsmlg2::Types::Flex1PropType
    xml_attributes :idrefs

    xml do
      element 'derivedFrom'
    end
  end

  # Represents the non-Concept value that was used for deriving the value of
  # one or more properties in this NewsML-G2 item.
  class DerivedFromValue < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_attributes :sourceidref, :idrefs

    xml do
      element 'derivedFromValue'
    end
  end

  # A set of properties directly associated with the Item.
  class ItemMeta < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::I18NAttributes
    include Newsmlg2::Base::ItemManagementGroup

    xml_element :links, xml: 'link',
                        type: Newsmlg2::Types::Link, collection: true
    xml_element :item_meta_ext_properties, xml: 'itemMetaExtProperty',
                                           type: Newsmlg2::Types::Flex2ExtPropType, collection: true

    xml do
      element 'itemMeta'
    end
  end

  # Abstract base of all G2 items. Item subclasses declare their own element
  # name ("newsItem", "packageItem", …) and content model.
  class AnyItem < Newsmlg2::NarModel
    include Newsmlg2::Base::I18NAttributes

    attribute :standard, :string, default: -> { 'NewsML-G2' }
    attribute :standardversion, :string, default: -> { Newsmlg2::SPEC_VERSION }
    attribute :conformance, :string, default: -> { 'power' }
    attribute :guid, :string
    attribute :version, :string, default: -> { '1' }

    xml do
      map_attribute 'standard', to: :standard, render_default: true
      map_attribute 'standardversion', to: :standardversion, render_default: true
      map_attribute 'conformance', to: :conformance, render_default: true
      map_attribute 'guid', to: :guid
      map_attribute 'version', to: :version, render_default: true
    end

    xml_element :catalog_refs, xml: 'catalogRef',
                               type: Newsmlg2::CatalogRef, collection: true
    xml_element :catalogs, xml: 'catalog',
                           type: Newsmlg2::Catalog, collection: true
    xml_element :hop_history, xml: 'hopHistory', type: Newsmlg2::HopHistory
    xml_element :pub_history, xml: 'pubHistory', type: Newsmlg2::PubHistory
    xml_element :rights_infos, xml: 'rightsInfo',
                               type: Newsmlg2::Types::RightsInfo, collection: true
    xml_element :item_meta, xml: 'itemMeta', type: Newsmlg2::ItemMeta

    # The elements of this item that carry catalogs and catalogRefs for the
    # document's CatalogStore (items carry them inline).
    def catalog_holders
      [self]
    end

    # Raises unless the item carries the attributes any NewsML-G2 item
    # requires before serialization.
    def validate!
      raise MissingGuidError, "#{self.class.name.split('::').last} needs a guid" if guid.to_s.empty?

      self
    end
  end
end
