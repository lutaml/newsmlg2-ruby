# frozen_string_literal: true

module Newsmlg2
  module Base
    module QuantifyAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes :confidence, :relevance, :derivedfrom
        end
      end
    end
  end
end
