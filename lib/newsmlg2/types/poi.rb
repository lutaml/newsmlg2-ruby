# frozen_string_literal: true

module Newsmlg2
  module Types
    # Opening hours of a point of interest, in natural language.
    class OpenHours < Label1Type
      xml do
        element 'openHours'
      end
    end

    # Total capacity of a point of interest, in natural language.
    class Capacity < Label1Type
      xml do
        element 'capacity'
      end
    end

    # Ways to access the place of the point of interest, including
    # directions.
    class Access < BlockType
      xml do
        element 'access'
      end
    end

    # Detailed information about the precise location of the point of
    # interest.
    class Details < BlockType
      xml do
        element 'details'
      end
    end

    # The date (and optionally the time) on which this Point of Interest was
    # created.
    class POICreated < TruncatedDateTimePropType
      xml do
        element 'created'
      end
    end

    # The date (and optionally the time) on which this Point of Interest
    # ceased to exist.
    class POICeasedToExist < TruncatedDateTimePropType
      xml do
        element 'ceasedToExist'
      end
    end

    # A group of properties specific to a point of interest.
    class POIDetails < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :position, xml: 'position',
                             type: Newsmlg2::Types::Position
      xml_element :address, xml: 'address',
                            type: Newsmlg2::Types::Address
      xml_element :open_hours, xml: 'openHours',
                               type: Newsmlg2::Types::OpenHours
      xml_element :capacity, xml: 'capacity',
                             type: Newsmlg2::Types::Capacity
      xml_element :contact_infos, xml: 'contactInfo',
                                  type: Newsmlg2::Types::ContactInfoType, collection: true
      xml_element :accesses, xml: 'access',
                             type: Newsmlg2::Types::Access, collection: true
      xml_element :details, xml: 'details',
                            type: Newsmlg2::Types::Details, collection: true
      xml_element :created, xml: 'created',
                            type: Newsmlg2::Types::POICreated
      xml_element :ceased_to_exist, xml: 'ceasedToExist',
                                    type: Newsmlg2::Types::POICeasedToExist

      xml do
        element 'POIDetails'
      end
    end
  end
end
