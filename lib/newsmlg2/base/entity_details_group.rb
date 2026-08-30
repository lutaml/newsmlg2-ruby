# frozen_string_literal: true

module Newsmlg2
  module Base
    # A group of properties defining the details of specific entities
    # (concepts.py EntityDetailsGroup).
    module EntityDetailsGroup
      def self.included(klass)
        klass.class_eval do
          xml_element :has_instruments, xml: 'hasInstrument',
                                        type: Newsmlg2::Types::HasInstrument, collection: true
          xml_element :person_details, xml: 'personDetails',
                                       type: Newsmlg2::Types::PersonDetails
          xml_element :organisation_details, xml: 'organisationDetails',
                                             type: Newsmlg2::Types::OrganisationDetails
          xml_element :geo_area_details, xml: 'geoAreaDetails',
                                         type: Newsmlg2::Types::GeoAreaDetails
          xml_element :poi_details, xml: 'POIDetails',
                                    type: Newsmlg2::Types::POIDetails
          xml_element :object_details, xml: 'objectDetails',
                                       type: Newsmlg2::Types::ObjectDetails
          xml_element :event_details, xml: 'eventDetails',
                                      type: Newsmlg2::Types::EventDetails
        end
      end
    end
  end
end
