# frozen_string_literal: true

module Newsmlg2
  module Types
    # Explicit dates of recurrence.
    class RDate < DateOptTimePropType
      xml do
        element 'rDate'
      end
    end

    # Rule for recurrence.
    class RRule < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::RecurrenceRuleAttributes

      xml do
        element 'rRule'
      end
    end

    # Explicit dates to be excluded from any recurrence.
    class ExDate < DateOptTimePropType
      xml do
        element 'exDate'
      end
    end

    # Rule for dates to be excluded from recurrence.
    class ExRule < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::RecurrenceRuleAttributes

      xml do
        element 'exRule'
      end
    end

    # The date the event commences.
    class Start < ApproximateDateTimePropType
      include Newsmlg2::Base::ConfirmationStatusAttributes
    end

    # The date the event ends.
    class End < ApproximateDateTimePropType
      include Newsmlg2::Base::ConfirmationStatusAttributes
    end

    # The period the event will last (xsd:duration value as content).
    class EventDuration < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::ConfirmationStatusAttributes

      xml_content
    end

    # DEPRECATED since 2.24: use confirmationstatus attributes instead.
    class Confirmation < QCodePropType
    end

    # All dates pertaining to the event.
    class Dates < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :start, xml: 'start', type: Newsmlg2::Types::Start
      xml_element :end, xml: 'end', type: Newsmlg2::Types::End
      xml_element :duration, xml: 'duration', type: Newsmlg2::Types::EventDuration
      xml_element :rdates, xml: 'rDate', type: Newsmlg2::Types::RDate, collection: true
      xml_element :rrules, xml: 'rRule', type: Newsmlg2::Types::RRule, collection: true
      xml_element :exdates, xml: 'exDate', type: Newsmlg2::Types::ExDate, collection: true
      xml_element :exrules, xml: 'exRule', type: Newsmlg2::Types::ExRule, collection: true
      xml_element :confirmation, xml: 'confirmation',
                                 type: Newsmlg2::Types::Confirmation

      xml do
        element 'dates'
      end
    end

    # Indicates the certainty of the occurrence of the event.
    class OccurStatus < QualPropType
    end

    # The planning of the news coverage of the event.
    class NewsCoverageStatus < QualPropType
    end

    # How and when to register for the event.
    class Registration < BlockType
    end

    # Indication of the accessibility of the event.
    class AccessStatus < QualPropType
    end

    # A requirement for participating in the event.
    class ParticipationRequirement < Flex1PropType
      xml_attributes :role, :roleuri
    end

    # A subject covered by the event.
    class EventDetailsSubject < Flex1ConceptPropType
    end

    # A location (geographical area or point of interest) where the event
    # takes place.
    class EventDetailsLocation < FlexLocationPropType
      xml_attributes :role, :roleuri
    end

    # A person or organisation participating in the event.
    class Participant < Flex1PartyPropType
    end

    # A person or organisation organising the event.
    class Organiser < Flex1PartyPropType
    end

    # Legacy structured information about intended coverage, scoped to an
    # event (the planning-item NewsCoverage is the modern form).
    class EventNewsCoverage < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :g2content_type, xml: 'g2contentType',
                                   type: Newsmlg2::G2ContentType
      xml_element :item_class, xml: 'itemClass',
                               type: Newsmlg2::Types::QualRelPropType
      xml_element :assigned_to, xml: 'assignedTo',
                                type: Newsmlg2::AssignedTo, collection: true
      xml_element :scheduled, xml: 'scheduled',
                              type: Newsmlg2::Scheduled
      xml_element :services, xml: 'service',
                             type: Newsmlg2::Types::QualPropType, collection: true
      xml_element :ed_notes, xml: 'edNote',
                             type: Newsmlg2::Types::BlockType, collection: true
      include Newsmlg2::Base::DescriptiveMetadataGroup

      xml_attributes :role, :roleuri
    end

    # A set of properties with details about an event.
    class EventDetails < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :dates, xml: 'dates', type: Newsmlg2::Types::Dates
      xml_element :occur_status, xml: 'occurStatus',
                                 type: Newsmlg2::Types::OccurStatus
      xml_element :news_coverage_status, xml: 'newsCoverageStatus',
                                         type: Newsmlg2::Types::NewsCoverageStatus
      xml_element :registrations, xml: 'registration',
                                  type: Newsmlg2::Types::Registration, collection: true
      xml_element :keywords, xml: 'keyword',
                             type: Newsmlg2::Types::Keyword, collection: true
      xml_element :access_statuses, xml: 'accessStatus',
                                    type: Newsmlg2::Types::AccessStatus, collection: true
      xml_element :participation_requirements, xml: 'participationRequirement',
                                               type: Newsmlg2::Types::ParticipationRequirement, collection: true
      xml_element :subjects, xml: 'subject',
                             type: Newsmlg2::Types::EventDetailsSubject, collection: true
      xml_element :locations, xml: 'location',
                              type: Newsmlg2::Types::EventDetailsLocation, collection: true
      xml_element :participants, xml: 'participant',
                                 type: Newsmlg2::Types::Participant, collection: true
      xml_element :organisers, xml: 'organiser',
                               type: Newsmlg2::Types::Organiser, collection: true
      xml_element :contact_infos, xml: 'contactInfo',
                                  type: Newsmlg2::Types::ContactInfoType, collection: true
      xml_element :languages, xml: 'language',
                              type: Newsmlg2::Types::Language, collection: true
      xml_element :news_coverages, xml: 'newsCoverage',
                                   type: Newsmlg2::Types::EventNewsCoverage, collection: true

      xml do
        element 'eventDetails'
      end
    end

    # Structured information about an event without a concept identifier,
    # used only with News Items.
    class Event < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :names, xml: 'name',
                          type: Newsmlg2::Types::ConceptNameType, collection: true
      xml_element :definitions, xml: 'definition',
                                type: Newsmlg2::Types::Definition, collection: true
      xml_element :notes, xml: 'note',
                          type: Newsmlg2::Types::Note, collection: true
      xml_element :facets, xml: 'facet',
                           type: Newsmlg2::Types::Facet, collection: true
      include Newsmlg2::Base::ConceptRelationshipsGroup

      xml_element :event_details, xml: 'eventDetails',
                                  type: Newsmlg2::Types::EventDetails

      xml do
        element 'event'
      end
    end

    # A wrapper for events in a News Item.
    class Events < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :events, xml: 'event',
                           type: Newsmlg2::Types::Event, collection: true

      xml do
        element 'events'
      end
    end
  end
end
