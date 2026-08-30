# frozen_string_literal: true

module Newsmlg2
  module Base
    module I18NAttributes
      def self.included(klass)
        klass.class_eval do
          xml_lang_attribute
          xml_attributes :dir
        end
      end
    end
  end
end
