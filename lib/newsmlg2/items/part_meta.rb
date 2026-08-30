# frozen_string_literal: true

module Newsmlg2
  # A delimiter for a piece of streaming media content, expressed in
  # various time formats.
  class TimeDelim < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_attributes(
      :start, :end, :timeunit, :timeunituri, :renditionref, :renditionrefuri
    )

    xml do
      element 'timeDelim'
    end
  end

  # A delimiter for a rectangular region in a piece of visual content.
  class RegionDelim < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_attributes :x, :y, :width, :height

    xml do
      element 'regionDelim'
    end
  end

  # The role of this part in the overall content stream.
  class PartMetaRole < Newsmlg2::Types::QualPropType
    xml do
      element 'role'
    end
  end

  # A set of properties describing a specific part of the content of the
  # Item.
  class PartMeta < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::I18NAttributes

    xml_attributes :partid, :seq, :contentrefs

    xml_element :icons, xml: 'icon',
                        type: Newsmlg2::Types::Icon, collection: true
    xml_element :time_delims, xml: 'timeDelim',
                              type: Newsmlg2::TimeDelim, collection: true
    xml_element :region_delim, xml: 'regionDelim',
                               type: Newsmlg2::RegionDelim
    xml_element :role, xml: 'role',
                       type: Newsmlg2::PartMetaRole
    include Newsmlg2::Base::AdministrativeMetadataGroup
    include Newsmlg2::Base::DescriptiveMetadataGroup

    xml_element :part_meta_ext_properties, xml: 'partMetaExtProperty',
                                           type: Newsmlg2::Types::Flex2ExtPropType, collection: true
    xml_element :signals, xml: 'signal',
                          type: Newsmlg2::Types::Signal, collection: true
    xml_element :ed_notes, xml: 'edNote',
                           type: Newsmlg2::Types::BlockType, collection: true
    xml_element :links, xml: 'link',
                        type: Newsmlg2::Types::Link, collection: true

    xml do
      element 'partMeta'
    end
  end
end
