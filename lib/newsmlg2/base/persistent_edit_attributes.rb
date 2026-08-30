# frozen_string_literal: true

module Newsmlg2
  module Base
    module PersistentEditAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes :id, :creator, :creatoruri, :modified
        end
      end
    end
  end
end
