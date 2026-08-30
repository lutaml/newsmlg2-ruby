# frozen_string_literal: true

module Newsmlg2
  module Types
    # Geographic coordinates.
    class GeoCoordinatesType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :latitude, :longitude, :altitude, :gpsdatum
    end

    # The coordinates of a location.
    class Position < GeoCoordinatesType
      xml do
        element 'position'
      end
    end

    # The date the geopolitical area was founded/established.
    class GeoAreaFounded < TruncatedDateTimePropType
      xml do
        element 'founded'
      end
    end

    # The date the geopolitical area was dissolved.
    class GeoAreaDissolved < TruncatedDateTimePropType
      xml do
        element 'dissolved'
      end
    end

    # A line as a geographic area.
    class GeoAreaLine < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :positions, xml: 'position',
                              type: Newsmlg2::Types::Position, collection: true

      xml do
        element 'line'
      end
    end

    # A circle as a geographic area.
    class GeoAreaCircle < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_attributes :radius, :radunit, :radunituri
      xml_element :positions, xml: 'position',
                              type: Newsmlg2::Types::Position, collection: true

      xml do
        element 'circle'
      end
    end

    # A polygon as a geographic area.
    class GeoAreaPolygon < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :positions, xml: 'position',
                              type: Newsmlg2::Types::Position, collection: true

      xml do
        element 'polygon'
      end
    end

    # A group of properties specific to a geopolitical area.
    class GeoAreaDetails < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_element :position, xml: 'position',
                             type: Newsmlg2::Types::Position
      xml_element :founded, xml: 'founded',
                            type: Newsmlg2::Types::GeoAreaFounded
      xml_element :dissolved, xml: 'dissolved',
                              type: Newsmlg2::Types::GeoAreaDissolved
      xml_element :lines, xml: 'line',
                          type: Newsmlg2::Types::GeoAreaLine, collection: true
      xml_element :circles, xml: 'circle',
                            type: Newsmlg2::Types::GeoAreaCircle, collection: true
      xml_element :polygons, xml: 'polygon',
                             type: Newsmlg2::Types::GeoAreaPolygon, collection: true

      xml do
        element 'geoAreaDetails'
      end
    end
  end
end
