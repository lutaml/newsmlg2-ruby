# frozen_string_literal: true

module Newsmlg2
  module Base
    module ConfirmationStatusAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes :confirmationstatus, :confirmationstatusuri
        end
      end
    end
  end
end
