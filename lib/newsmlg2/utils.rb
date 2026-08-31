# frozen_string_literal: true

module Newsmlg2
  # QCode <-> URI conversion. The implementation lives on CatalogStore,
  # which owns the schemes both directions resolve through; this module is
  # the module-function convenience over a store or a document.
  module Utils
    module_function

    # @see Newsmlg2::CatalogStore#qcode_to_uri
    def qcode_to_uri(qcode, store_or_document)
      catalog_store_for(store_or_document).qcode_to_uri(qcode)
    end

    # @see Newsmlg2::CatalogStore#uri_to_qcode
    def uri_to_qcode(uri, store_or_document)
      catalog_store_for(store_or_document).uri_to_qcode(uri)
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
