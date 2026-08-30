# frozen_string_literal: true

module Newsmlg2
  module Base
    module RankingAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes :rank
        end
      end
    end
  end
end
