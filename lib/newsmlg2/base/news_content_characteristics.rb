# frozen_string_literal: true

module Newsmlg2
  module Base
    module NewsContentCharacteristics
      def self.included(klass)
        klass.class_eval do
          xml_attributes(
            :charcount, :wordcount, :linecount, :pagecount,
            :width, :widthunit, :widthunituri,
            :height, :heightunit, :heightunituri,
            :orientation,
            :layoutorientation, :layoutorientationuri,
            :colourspace, :colourspaceuri,
            :colourindicator, :colourindicatoruri,
            :colourdepth, :resolution,
            :duration, :durationunit, :durationunituri,
            :audiocodec, :audiocodecuri, :audiobitrate, :audiovbr,
            :audiosamplesize, :audiosamplerate,
            :audiochannels, :audiochannelsuri,
            :videocodec, :videocodecuri, :videoavgbitrate, :videovbr,
            :videoframerate, :videoscan, :videoaspectratio, :videosampling,
            :videoscaling, :videoscalinguri,
            :videodefinition, :videodefinitionuri
          )
        end
      end
    end
  end
end
