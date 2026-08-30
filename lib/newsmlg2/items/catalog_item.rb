# frozen_string_literal: true

module Newsmlg2
  # The container of a single catalog.
  class CatalogContainer < Newsmlg2::NarModel
    xml_element :catalog, xml: 'catalog', type: Newsmlg2::Catalog

    xml do
      element 'catalogContainer'
    end
  end

  # An Item containing a single managed NewsML-G2 catalog.
  class CatalogItem < AnyItem
    xml_element :content_meta, xml: 'contentMeta',
                               type: Newsmlg2::ContentMetaCat
    xml_element :catalog_container, xml: 'catalogContainer',
                                    type: Newsmlg2::CatalogContainer

    xml do
      element 'catalogItem'
    end
  end
end
