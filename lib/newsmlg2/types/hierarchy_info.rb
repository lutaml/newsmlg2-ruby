# frozen_string_literal: true

module Newsmlg2
  module Types
    # Position of a concept in a hierarchical taxonomy tree, expressed by a
    # sequence of QCode tokens as element content.
    class HierarchyInfo < Newsmlg2::NarModel
      include Newsmlg2::Base::CommonPowerAttributes

      xml_content

      xml do
        element 'hierarchyInfo'
      end
    end
  end
end
