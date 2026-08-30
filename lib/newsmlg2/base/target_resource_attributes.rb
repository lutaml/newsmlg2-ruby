# frozen_string_literal: true

module Newsmlg2
  module Base
    # A group of attributes pertaining to any kind of link (link.py).
    module TargetResourceAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes(
            :href, :residref, :version, :persistidref,
            :contenttype, :contenttypestandardversion,
            :contenttypevariant, :contenttypevariantstandardversion,
            :format, :formaturi, :formatstandardversion,
            :size, :title
          )
        end
      end
    end
  end
end
