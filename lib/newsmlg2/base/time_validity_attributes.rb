# frozen_string_literal: true

module Newsmlg2
  module Base
    module TimeValidityAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes :validfrom, :validto
        end
      end
    end
  end
end
