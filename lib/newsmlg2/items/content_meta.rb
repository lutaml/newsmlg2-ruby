# frozen_string_literal: true

module Newsmlg2
  # The full content metadata type (administrative + full descriptive
  # properties) used by news and package items; element name "contentMeta"
  # is declared by the owning item.
  class ContentMeta < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::I18NAttributes

    # python-newsmlg2 fixtures carry an in-namespace <name> inside
    # contentMeta (an xs:any-style provider extension in those files);
    # modelled so the value round-trips instead of being hoisted.
    xml_element :names, xml: 'name',
                        type: Newsmlg2::Types::ConceptNameType, collection: true
    xml_element :icons, xml: 'icon',
                        type: Newsmlg2::Types::Icon, collection: true
    include Newsmlg2::Base::AdministrativeMetadataGroup
    include Newsmlg2::Base::DescriptiveMetadataGroup

    xml_element :content_meta_ext_properties, xml: 'contentMetaExtProperty',
                                              type: Newsmlg2::Types::Flex2ExtPropType, collection: true

    xml do
      element 'contentMeta'
    end
  end

  # Content metadata with the core descriptive set, used by concept,
  # knowledge and planning items.
  class ContentMetaAcD < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::I18NAttributes

    # python-newsmlg2 fixtures carry an in-namespace <name> inside
    # contentMeta (an xs:any-style provider extension in those files);
    # modelled so the value round-trips instead of being hoisted.
    xml_element :names, xml: 'name',
                        type: Newsmlg2::Types::ConceptNameType, collection: true
    xml_element :icons, xml: 'icon',
                        type: Newsmlg2::Types::Icon, collection: true
    include Newsmlg2::Base::AdministrativeMetadataGroup
    include Newsmlg2::Base::DescriptiveMetadataCoreGroup

    xml_element :content_meta_ext_properties, xml: 'contentMetaExtProperty',
                                              type: Newsmlg2::Types::Flex2ExtPropType, collection: true

    xml do
      element 'contentMeta'
    end
  end

  # The restricted content metadata of a catalog item.
  class ContentMetaCat < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::I18NAttributes

    xml_element :content_created, xml: 'contentCreated',
                                  type: Newsmlg2::Types::TruncatedDateTimePropType
    xml_element :content_modified, xml: 'contentModified',
                                   type: Newsmlg2::Types::TruncatedDateTimePropType
    xml_element :creators, xml: 'creator',
                           type: Newsmlg2::Types::FlexAuthorPropType, collection: true
    xml_element :contributors, xml: 'contributor',
                               type: Newsmlg2::Types::FlexAuthorPropType, collection: true
    xml_element :alt_ids, xml: 'altId',
                          type: Newsmlg2::Types::AltId, collection: true

    xml do
      element 'contentMeta'
    end
  end
end
