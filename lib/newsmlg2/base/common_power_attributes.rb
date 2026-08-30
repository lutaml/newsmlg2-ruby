# frozen_string_literal: true

module Newsmlg2
  module Base
    module CommonPowerAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes(
            :id, :creator, :creatoruri, :modified, :custom,
            :how, :howuri, :why, :whyuri,
            :pubconstraint, :pubconstrainturi
          )
        end
      end
    end
  end
end
