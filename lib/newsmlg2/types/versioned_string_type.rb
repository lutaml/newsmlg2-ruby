# frozen_string_literal: true

module Newsmlg2
  module Types
    # IntlStringType extended by a version information attribute.
    class VersionedStringType < IntlStringType
      xml_attributes :versioninfo
    end
  end
end
