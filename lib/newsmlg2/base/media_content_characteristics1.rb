# frozen_string_literal: true

module Newsmlg2
  module Base
    module MediaContentCharacteristics1
      def self.included(klass)
        klass.class_eval do
          xml_attributes(
            :width, :widthunit, :widthunituri,
            :height, :heightunit, :heightunituri,
            :orientation,
            :layoutorientation, :layoutorientationuri,
            :colourspace, :colourspaceuri,
            :colourindicator, :colourindicatoruri,
            :videocodec, :videocodecuri,
            :colourdepth
          )
        end
      end
    end
  end
end
