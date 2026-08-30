# frozen_string_literal: true

module Newsmlg2
  # QCode <-> URI conversion using a document's catalogs.
  module Utils
    module_function

    # Expands a qcode (e.g. "ninat:text") to its full concept URI using the
    # schemes declared in the document's catalogs.
    #
    # @raise [Newsmlg2::AliasNotFoundInCatalogs]
    def qcode_to_uri(qcode, store_or_document)
      store = catalog_store_for(store_or_document)
      alias_name, code = qcode.split(':', 2)
      raise ArgumentError, "not a qcode: #{qcode.inspect}" if code.nil?

      store.get_scheme_for_alias(alias_name).uri + code
    end

    # Compresses a concept URI back to a qcode using the schemes declared in
    # the document's catalogs.
    #
    # @raise [Newsmlg2::UriNotFoundInCatalogs]
    def uri_to_qcode(uri, store_or_document)
      store = catalog_store_for(store_or_document)
      idx = uri.rindex('/')
      raise ArgumentError, "not a concept URI: #{uri.inspect}" unless idx

      scheme_uri = uri[0..idx]
      code = uri[(idx + 1)..]
      "#{store.get_scheme_for_uri(scheme_uri).alias_attr}:#{code}"
    end

    def catalog_store_for(store_or_document)
      if store_or_document.is_a?(CatalogStore)
        store_or_document
      else
        store_or_document.catalog_store
      end
    end
  end
end
