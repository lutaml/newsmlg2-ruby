# frozen_string_literal: true

module Newsmlg2
  module Types
    # Flexible generic type for both controlled and uncontrolled values.
    class FlexPropType < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes
      include Newsmlg2::Base::FlexAttributes
      include Newsmlg2::Base::I18NAttributes

      xml_element :names, xml: 'name',
                          type: Newsmlg2::Types::ConceptNameType, collection: true
      xml_element :hierarchy_info, xml: 'hierarchyInfo',
                                   type: Newsmlg2::Types::HierarchyInfo, collection: true
    end
  end
end
