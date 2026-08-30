# frozen_string_literal: true

module Newsmlg2
  module Base
    module QualifyingAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes :qcode, :uri, :literal, :type, :typeuri, :role, :roleuri
        end
      end
    end
  end
end
