# frozen_string_literal: true

module Newsmlg2
  module Base
    # A group of properties associated with the administrative facet of
    # content (contentmeta.py).
    module AdministrativeMetadataGroup
      def self.included(klass)
        klass.class_eval do
          xml_element :urgency, xml: 'urgency',
                                type: Newsmlg2::Types::Urgency
          xml_element :content_created, xml: 'contentCreated',
                                        type: Newsmlg2::Types::TruncatedDateTimePropType
          xml_element :content_modified, xml: 'contentModified',
                                         type: Newsmlg2::Types::TruncatedDateTimePropType
          xml_element :digital_source_type, xml: 'digitalSourceType',
                                            type: Newsmlg2::Types::DigitalSourceType
          xml_element :located, xml: 'located',
                                type: Newsmlg2::Types::FlexLocationPropType, collection: true
          xml_element :info_sources, xml: 'infoSource',
                                     type: Newsmlg2::Types::Flex1PartyPropType, collection: true
          xml_element :creators, xml: 'creator',
                                 type: Newsmlg2::Types::FlexAuthorPropType, collection: true
          xml_element :contributors, xml: 'contributor',
                                     type: Newsmlg2::Types::FlexAuthorPropType, collection: true
          xml_element :audiences, xml: 'audience',
                                  type: Newsmlg2::Types::Audience, collection: true
          xml_element :excl_audiences, xml: 'exclaudience',
                                       type: Newsmlg2::Types::ExclAudience, collection: true
          xml_element :alt_ids, xml: 'altId',
                                type: Newsmlg2::Types::AltId, collection: true
          xml_element :ratings, xml: 'rating',
                                type: Newsmlg2::Types::Rating, collection: true
          xml_element :user_interactions, xml: 'userInteraction',
                                          type: Newsmlg2::Types::UserInteraction, collection: true
        end
      end
    end
  end
end
