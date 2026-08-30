# frozen_string_literal: true

module Newsmlg2
  module Base
    module NewsContentAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes(
            :id, :creator, :creatoruri, :modified, :custom,
            :how, :howuri, :why, :whyuri,
            :rendition, :renditionuri,
            :generator, :generated, :hascontent
          )
        end
      end
    end
  end
end
