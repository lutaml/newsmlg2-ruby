# frozen_string_literal: true

module Newsmlg2
  # A reference to a group local to the package.
  class GroupRef < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_attributes :idref

    xml do
      element 'groupRef'
    end
  end

  # A reference to a target concept.
  class ConceptRef < Newsmlg2::Types::FlexPropType
  end

  # A mixed set of group references and references to items or Web
  # resources.
  class Group < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::I18NAttributes

    xml_attributes :role, :roleuri, :mode, :modeuri

    xml_element :group_refs, xml: 'groupRef',
                             type: Newsmlg2::GroupRef, collection: true
    xml_element :item_refs, xml: 'itemRef',
                            type: Newsmlg2::ItemRef, collection: true
    xml_element :concept_refs, xml: 'conceptRef',
                               type: Newsmlg2::ConceptRef, collection: true
    xml_element :titles, xml: 'title',
                         type: Newsmlg2::Types::Label1Type, collection: true
    xml_element :signals, xml: 'signal',
                          type: Newsmlg2::Types::Signal, collection: true
    xml_element :ed_notes, xml: 'edNote',
                           type: Newsmlg2::Types::BlockType, collection: true
    xml_element :group_ext_properties, xml: 'groupExtProperty',
                                       type: Newsmlg2::Types::Flex2ExtPropType, collection: true

    xml do
      element 'group'
    end
  end

  # A hierarchical set of groups.
  class GroupSet < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_attributes :root

    xml_element :groups, xml: 'group',
                         type: Newsmlg2::Group, collection: true

    xml do
      element 'groupSet'
    end
  end

  # An Item used for packaging references to other Items and Web resources.
  class PackageItem < AnyItem
    xml_element :content_meta, xml: 'contentMeta',
                               type: Newsmlg2::ContentMeta
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
    xml_element :group_set, xml: 'groupSet',
                            type: Newsmlg2::GroupSet

    xml do
      element 'packageItem'
    end
  end
end
