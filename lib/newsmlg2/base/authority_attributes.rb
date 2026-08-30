# frozen_string_literal: true

module Newsmlg2
  module Base
    # Added in NewsML-G2 2.32.
    module AuthorityAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes :authority, :authoritystatus, :authoritystatusuri
        end
      end
    end
  end
end
