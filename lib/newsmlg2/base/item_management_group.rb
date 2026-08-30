# frozen_string_literal: true

module Newsmlg2
  module Base
    # A group of properties for the management of the item
    # (itemmanagement.py / XSD ItemManagementGroup). Element order follows the
    # XSD sequence.
    module ItemManagementGroup
      def self.included(klass)
        klass.class_eval do
          xml_element :item_class, xml: 'itemClass',
                                   type: Newsmlg2::Types::QualRelPropType
          xml_element :provider, xml: 'provider',
                                 type: Newsmlg2::Types::FlexPartyPropType
          xml_element :version_created, xml: 'versionCreated',
                                        type: Newsmlg2::Types::DateTimePropType
          xml_element :first_created, xml: 'firstCreated',
                                      type: Newsmlg2::Types::DateTimePropType
          xml_element :embargoed, xml: 'embargoed',
                                  type: Newsmlg2::Types::DateTimeOrNullPropType
          xml_element :pub_status, xml: 'pubStatus',
                                   type: Newsmlg2::Types::QualPropType
          xml_element :role, xml: 'role', type: Newsmlg2::Types::QualPropType
          xml_element :file_name, xml: 'fileName', type: Newsmlg2::Types::FileName
          xml_element :generators, xml: 'generator',
                                   type: Newsmlg2::Types::Generator, collection: true
          xml_element :profile, xml: 'profile',
                                type: Newsmlg2::Types::VersionedStringType
          xml_element :services, xml: 'service',
                                 type: Newsmlg2::Types::QualPropType, collection: true
          xml_element :titles, xml: 'title',
                               type: Newsmlg2::Types::Label1Type, collection: true
          xml_element :ed_notes, xml: 'edNote',
                                 type: Newsmlg2::Types::BlockType, collection: true
          xml_element :member_of, xml: 'memberOf',
                                  type: Newsmlg2::Types::Flex1PropType, collection: true
          xml_element :instance_of, xml: 'instanceOf',
                                    type: Newsmlg2::Types::Flex1PropType, collection: true
          xml_element :signals, xml: 'signal',
                                type: Newsmlg2::Types::Signal, collection: true
          xml_element :alt_reps, xml: 'altRep',
                                 type: Newsmlg2::Types::AltRep, collection: true
          xml_element :deliverable_of, xml: 'deliverableOf',
                                       type: Newsmlg2::Types::Link1Type, collection: true
          xml_element :hashes, xml: 'hash',
                               type: Newsmlg2::Types::Hash, collection: true
          xml_element :expires, xml: 'expires',
                                type: Newsmlg2::Types::DateOptTimePropType, collection: true
          xml_element :orig_reps, xml: 'origRep',
                                  type: Newsmlg2::Types::OrigRep, collection: true
          xml_element :incoming_feed_ids, xml: 'incomingFeedId',
                                          type: Newsmlg2::Types::IncomingFeedId, collection: true
          xml_element :metadata_creator, xml: 'metadataCreator',
                                         type: Newsmlg2::Types::FlexAuthorPropType
        end
      end
    end
  end
end
