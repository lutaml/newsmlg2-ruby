# frozen_string_literal: true

module Newsmlg2
  module Base
    module NewsContentTypeAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes(
            :contenttype, :contenttypestandardversion,
            :contenttypevariant, :contenttypevariantstandardversion,
            :format, :formaturi, :formatstandardversion
          )
        end
      end
    end
  end
end
