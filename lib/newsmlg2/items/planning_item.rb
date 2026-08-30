# frozen_string_literal: true

module Newsmlg2
  # The kind of planned G2 item(s).
  class G2ContentType < Newsmlg2::Types::QCodePropType
    xml_content

    xml do
      element 'g2contentType'
    end
  end

  # Number of planned G2 items of this kind expressed by a range.
  class ItemCount < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_attributes :rangefrom, :rangeto

    xml do
      element 'itemCount'
    end
  end

  # The party which is assigned to cover the event and produce the planned
  # G2 item.
  class AssignedTo < Newsmlg2::Types::Flex1PartyPropType
    xml_attributes :coversfrom, :coversto

    xml do
      element 'assignedTo'
    end
  end

  # The scheduled time of delivery for the planned G2 item(s).
  class Scheduled < Newsmlg2::Types::ApproximateDateTimePropType
    xml do
      element 'scheduled'
    end
  end

  # The characteristics of the content of a News Item.
  class NewsContentCharacteristicsElement < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::NewsContentTypeAttributes
    include Newsmlg2::Base::NewsContentCharacteristics

    xml do
      element 'newsContentCharacteristics'
    end
  end

  # Details about the planned news coverage by a specific kind of G2 item.
  class Planning < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_element :g2content_type, xml: 'g2contentType',
                                 type: Newsmlg2::G2ContentType
    xml_element :item_class, xml: 'itemClass',
                             type: Newsmlg2::Types::QualRelPropType
    xml_element :item_count, xml: 'itemCount',
                             type: Newsmlg2::ItemCount
    xml_element :assigned_to, xml: 'assignedTo',
                              type: Newsmlg2::AssignedTo, collection: true
    xml_element :scheduled, xml: 'scheduled',
                            type: Newsmlg2::Scheduled
    xml_element :services, xml: 'service',
                           type: Newsmlg2::Types::QualPropType, collection: true
    include Newsmlg2::Base::DescriptiveMetadataGroup

    xml_element :ed_notes, xml: 'edNote',
                           type: Newsmlg2::Types::BlockType, collection: true
    xml_element :news_content_characteristics, xml: 'newsContentCharacteristics',
                                               type: Newsmlg2::NewsContentCharacteristicsElement
    xml_element :urgency, xml: 'urgency',
                          type: Newsmlg2::Types::Urgency
    xml_element :audience, xml: 'audience',
                           type: Newsmlg2::Types::Audience
    xml_element :excl_audiences, xml: 'exclaudience',
                                 type: Newsmlg2::Types::ExclAudience, collection: true
    xml_element :planning_ext_properties, xml: 'planningExtProperty',
                                          type: Newsmlg2::Types::Flex2ExtPropType, collection: true

    xml_attributes :coversfrom, :coversto

    xml do
      element 'planning'
    end
  end

  # A reference to a G2 item which has been delivered under this news
  # coverage definition.
  class DeliveredItemRef < Newsmlg2::Types::Link1Type
    xml do
      element 'deliveredItemRef'
    end
  end

  # A set of references to G2 items which have been delivered under this
  # news coverage definition.
  class Delivery < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_element :delivered_item_refs, xml: 'deliveredItemRef',
                                      type: Newsmlg2::DeliveredItemRef, collection: true

    xml do
      element 'delivery'
    end
  end

  # Information about the planned and delivered news coverage of the news
  # provider.
  class NewsCoverage < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_element :planning, xml: 'planning',
                           type: Newsmlg2::Planning, collection: true
    xml_element :delivery, xml: 'delivery',
                           type: Newsmlg2::Delivery
    xml_element :news_coverage_ext_properties, xml: 'newsCoverageExtProperty',
                                               type: Newsmlg2::Types::Flex2ExtPropType, collection: true

    xml do
      element 'newsCoverage'
    end
  end

  # A set of data about planned and delivered news coverage.
  class NewsCoverageSet < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes

    xml_element :news_coverages, xml: 'newsCoverage',
                                 type: Newsmlg2::NewsCoverage, collection: true

    xml do
      element 'newsCoverageSet'
    end
  end

  # An Item containing information about the planning and delivery of news
  # coverage.
  class PlanningItem < AnyItem
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
    xml_element :news_coverage_sets, xml: 'newsCoverageSet',
                                     type: Newsmlg2::NewsCoverageSet, collection: true

    xml do
      element 'planningItem'
    end
  end
end
