# frozen_string_literal: true

module Newsmlg2
  module Types
    # Flexible location (geopolitical area or point-of-interest) data type.
    class FlexLocationPropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::FlexAttributes
      include Newsmlg2::Base::I18NAttributes
      include Newsmlg2::Base::ConceptDefinitionGroup
      include Newsmlg2::Base::ConceptRelationshipsGroup

      xml_element :geo_area_details, xml: 'geoAreaDetails',
                                     type: Newsmlg2::Types::GeoAreaDetails
      xml_element :poi_details, xml: 'POIDetails',
                                type: Newsmlg2::Types::POIDetails
    end

    # Flexible point-of-interest data type.
    class FlexPOIPropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::FlexAttributes
      include Newsmlg2::Base::I18NAttributes
      include Newsmlg2::Base::ConceptDefinitionGroup
      include Newsmlg2::Base::ConceptRelationshipsGroup

      xml_element :poi_details, xml: 'POIDetails',
                                type: Newsmlg2::Types::POIDetails
    end

    # Flexible geopolitical area data type.
    class FlexGeoAreaPropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::FlexAttributes
      include Newsmlg2::Base::I18NAttributes
      include Newsmlg2::Base::ConceptDefinitionGroup
      include Newsmlg2::Base::ConceptRelationshipsGroup

      xml_element :geo_area_details, xml: 'geoAreaDetails',
                                     type: Newsmlg2::Types::GeoAreaDetails
    end
  end
end
