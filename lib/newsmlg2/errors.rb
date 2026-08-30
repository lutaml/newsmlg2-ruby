# frozen_string_literal: true

module Newsmlg2
  class Error < StandardError; end

  # No catalog known to the document declares this scheme alias.
  class AliasNotFoundInCatalogs < Error; end

  # No catalog known to the document declares this scheme URI.
  class UriNotFoundInCatalogs < Error; end
  URINotFoundInCatalogs = UriNotFoundInCatalogs

  # The parsed root element is not a NewsML-G2 item or newsMessage.
  class UnknownRootElement < Error; end

  # An item without a guid cannot be serialized.
  class MissingGuidError < Error; end
end
