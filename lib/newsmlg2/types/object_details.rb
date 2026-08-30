# frozen_string_literal: true

module Newsmlg2
  module Types
    # The date (and optionally the time) on which this object was created.
    class ObjectCreated < TruncatedDateTimePropType
      xml do
        element 'created'
      end
    end

    # The date (and optionally the time) on which this object ceased to
    # exist.
    class ObjectCeasedToExist < TruncatedDateTimePropType
      xml do
        element 'ceasedToExist'
      end
    end

    # A group of properties specific to an object. Kept in its own file so
    # the party detail types and the rights types never load each other
    # mid-flight.
    class ObjectDetails < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :created, xml: 'created',
                            type: Newsmlg2::Types::ObjectCreated
      xml_element :copyright_notices, xml: 'copyrightNotice',
                                      type: Newsmlg2::Types::CopyrightNotice, collection: true
      xml_element :creators, xml: 'creator',
                             type: Newsmlg2::Types::FlexAuthorPropType, collection: true
      xml_element :ceased_to_exist, xml: 'ceasedToExist',
                                    type: Newsmlg2::Types::ObjectCeasedToExist

      xml do
        element 'objectDetails'
      end
    end
  end
end
