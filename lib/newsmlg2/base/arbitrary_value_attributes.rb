# frozen_string_literal: true

module Newsmlg2
  module Base
    module ArbitraryValueAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes :value, :valuedatatype, :valueunit, :valueunituri
        end
      end
    end
  end
end
