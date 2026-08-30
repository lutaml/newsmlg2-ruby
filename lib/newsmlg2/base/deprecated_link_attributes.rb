# frozen_string_literal: true

module Newsmlg2
  module Base
    # Deprecated attributes once used for target identifiers (link.py).
    module DeprecatedLinkAttributes
      def self.included(klass)
        klass.class_eval do
          xml_attributes :guidref, :hreftype
        end
      end
    end
  end
end
