# frozen_string_literal: true

module Newsmlg2
  module Base
    module FlexAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes :qcode, :uri, :literal, :type, :typeuri
        end
      end
    end
  end
end
