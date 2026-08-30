# frozen_string_literal: true

module Newsmlg2
  module Base
    # A group of properties associated with the full descriptive facet of
    # news-related content (contentmeta.py).
    module DescriptiveMetadataGroup
      def self.included(klass)
        klass.class_eval do
          xml_element :languages, xml: 'language',
                                  type: Newsmlg2::Types::Language, collection: true
          xml_element :genres, xml: 'genre',
                               type: Newsmlg2::Types::Genre, collection: true
          xml_element :keywords, xml: 'keyword',
                                 type: Newsmlg2::Types::Keyword, collection: true
          xml_element :subjects, xml: 'subject',
                                 type: Newsmlg2::Types::Subject, collection: true
          xml_element :sluglines, xml: 'slugline',
                                  type: Newsmlg2::Types::Slugline, collection: true
          xml_element :headlines, xml: 'headline',
                                  type: Newsmlg2::Types::Headline, collection: true
          xml_element :datelines, xml: 'dateline',
                                  type: Newsmlg2::Types::Dateline, collection: true
          xml_element :by, xml: 'by', type: Newsmlg2::Types::By, collection: true
          xml_element :creditlines, xml: 'creditline',
                                    type: Newsmlg2::Types::Creditline, collection: true
          xml_element :descriptions, xml: 'description',
                                     type: Newsmlg2::Types::ContentDescription, collection: true
        end
      end
    end

    # The core subset of the descriptive facet (no genre, dateline, by,
    # creditline) — used by concept, knowledge, planning and catalog items.
    module DescriptiveMetadataCoreGroup
      def self.included(klass)
        klass.class_eval do
          xml_element :languages, xml: 'language',
                                  type: Newsmlg2::Types::Language, collection: true
          xml_element :keywords, xml: 'keyword',
                                 type: Newsmlg2::Types::Keyword, collection: true
          xml_element :subjects, xml: 'subject',
                                 type: Newsmlg2::Types::Subject, collection: true
          xml_element :sluglines, xml: 'slugline',
                                  type: Newsmlg2::Types::Slugline, collection: true
          xml_element :headlines, xml: 'headline',
                                  type: Newsmlg2::Types::Headline, collection: true
          xml_element :descriptions, xml: 'description',
                                     type: Newsmlg2::Types::ContentDescription, collection: true
        end
      end
    end
  end
end
