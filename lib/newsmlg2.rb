# frozen_string_literal: true

require 'lutaml/model'

# Newsmlg2 is a lutaml-model-based object model for IPTC NewsML-G2 (NAR):
# parse, manipulate, build and serialize NewsML-G2 XML with round-trip
# fidelity. Targets specification version 2.35, power conformance.
module Newsmlg2
  # The NewsML-G2 specification version this library models; used as the
  # default standardversion of serialized items.
  SPEC_VERSION = '2.35'

  autoload :VERSION, 'newsmlg2/version'

  # Shared mixin groups (XSD attribute groups and element groups).
  autoload :Base, 'newsmlg2/base'

  # Shared value types (XSD complex types usable as element payloads).
  autoload :Types, 'newsmlg2/types'

  # Item model classes (XSD item types and their structural children).
  autoload :Action, 'newsmlg2/items/any_item'
  autoload :AltLoc, 'newsmlg2/items/news_item'
  autoload :AnyItem, 'newsmlg2/items/any_item'
  autoload :Assert, 'newsmlg2/items/any_item'
  autoload :AssignedTo, 'newsmlg2/items/planning_item'
  autoload :CatalogContainer, 'newsmlg2/items/catalog_item'
  autoload :CatalogItem, 'newsmlg2/items/catalog_item'
  autoload :Channel, 'newsmlg2/items/news_item'
  autoload :ConceptItem, 'newsmlg2/items/concept_item'
  autoload :ConceptRef, 'newsmlg2/items/package_item'
  autoload :ConceptSet, 'newsmlg2/items/knowledge_item'
  autoload :ContentMeta, 'newsmlg2/items/content_meta'
  autoload :ContentMetaAcD, 'newsmlg2/items/content_meta'
  autoload :ContentMetaCat, 'newsmlg2/items/content_meta'
  autoload :ContentSet, 'newsmlg2/items/news_item'
  autoload :DeliveredItemRef, 'newsmlg2/items/planning_item'
  autoload :Delivery, 'newsmlg2/items/planning_item'
  autoload :DerivedFrom, 'newsmlg2/items/any_item'
  autoload :DerivedFromValue, 'newsmlg2/items/any_item'
  autoload :Destination, 'newsmlg2/items/news_message'
  autoload :G2ContentType, 'newsmlg2/items/planning_item'
  autoload :Group, 'newsmlg2/items/package_item'
  autoload :GroupRef, 'newsmlg2/items/package_item'
  autoload :GroupSet, 'newsmlg2/items/package_item'
  autoload :Header, 'newsmlg2/items/news_message'
  autoload :Hop, 'newsmlg2/items/any_item'
  autoload :HopHistory, 'newsmlg2/items/any_item'
  autoload :InlineData, 'newsmlg2/items/news_item'
  autoload :InlineRef, 'newsmlg2/items/any_item'
  autoload :InlineXML, 'newsmlg2/items/news_item'
  autoload :ItemCount, 'newsmlg2/items/planning_item'
  autoload :ItemMeta, 'newsmlg2/items/any_item'
  autoload :ItemRef, 'newsmlg2/items/item_ref'
  autoload :ItemSet, 'newsmlg2/items/news_message'
  autoload :KnowledgeItem, 'newsmlg2/items/knowledge_item'
  autoload :MessageChannel, 'newsmlg2/items/news_message'
  autoload :MessageTimestamp, 'newsmlg2/items/news_message'
  autoload :NewsContentCharacteristicsElement, 'newsmlg2/items/planning_item'
  autoload :NewsCoverage, 'newsmlg2/items/planning_item'
  autoload :NewsCoverageSet, 'newsmlg2/items/planning_item'
  autoload :NewsItem, 'newsmlg2/items/news_item'
  autoload :NewsMessage, 'newsmlg2/items/news_message'
  autoload :Origin, 'newsmlg2/items/news_message'
  autoload :PackageItem, 'newsmlg2/items/package_item'
  autoload :PartMeta, 'newsmlg2/items/part_meta'
  autoload :PartMetaRole, 'newsmlg2/items/part_meta'
  autoload :Planning, 'newsmlg2/items/planning_item'
  autoload :PlanningItem, 'newsmlg2/items/planning_item'
  autoload :Priority, 'newsmlg2/items/news_message'
  autoload :PubHistory, 'newsmlg2/items/any_item'
  autoload :Published, 'newsmlg2/items/any_item'
  autoload :RegionDelim, 'newsmlg2/items/part_meta'
  autoload :RemoteContent, 'newsmlg2/items/news_item'
  autoload :Scheduled, 'newsmlg2/items/planning_item'
  autoload :SchemeMeta, 'newsmlg2/items/knowledge_item'
  autoload :Sender, 'newsmlg2/items/news_message'
  autoload :Sent, 'newsmlg2/items/news_message'
  autoload :StringType, 'newsmlg2/items/news_message'
  autoload :TimeDelim, 'newsmlg2/items/part_meta'
  autoload :Timestamp, 'newsmlg2/items/any_item'

  # Catalog subsystem (qcode resolution).
  autoload :Catalog, 'newsmlg2/catalog'
  autoload :CatalogCache, 'newsmlg2/catalog_cache'
  autoload :CatalogRef, 'newsmlg2/catalog_ref'
  autoload :CatalogStore, 'newsmlg2/catalog_store'
  autoload :Scheme, 'newsmlg2/scheme'
  autoload :SameAsScheme, 'newsmlg2/same_as_scheme'

  # Document entry point and support.
  autoload :Adapter, 'newsmlg2/adapter'
  autoload :AliasNotFoundInCatalogs, 'newsmlg2/errors'
  autoload :Builder, 'newsmlg2/builder'
  autoload :Configuration, 'newsmlg2/configuration'
  autoload :Document, 'newsmlg2/document'
  autoload :Error, 'newsmlg2/errors'
  autoload :I18n, 'newsmlg2/i18n'
  autoload :MissingGuidError, 'newsmlg2/errors'
  autoload :NarModel, 'newsmlg2/nar_model'
  autoload :NarNamespace, 'newsmlg2/nar_namespace'
  autoload :NitfNamespace, 'newsmlg2/nitf_namespace'
  autoload :UnknownRootElement, 'newsmlg2/errors'
  autoload :UriNotFoundInCatalogs, 'newsmlg2/errors'

  class << self
    # Parses NewsML-G2 XML (any item type or a newsMessage envelope).
    #
    # @return [Newsmlg2::Document]
    def parse(xml)
      Document.parse(xml)
    end

    # Parses a NewsML-G2 XML file.
    #
    # @return [Newsmlg2::Document]
    def parse_file(path)
      Document.parse_file(path)
    end

    # Expands a qcode (e.g. "ninat:text") to its full concept URI using the
    # catalogs of the given document (or a CatalogStore).
    #
    # @raise [Newsmlg2::AliasNotFoundInCatalogs]
    def qcode_to_uri(qcode, store_or_document)
      store_for(store_or_document).qcode_to_uri(qcode)
    end

    # Compresses a concept URI back to a qcode using the given document's
    # catalogs (or a CatalogStore).
    #
    # @raise [Newsmlg2::UriNotFoundInCatalogs]
    def uri_to_qcode(uri, store_or_document)
      store_for(store_or_document).uri_to_qcode(uri)
    end

    # Builder DSL entry points (see Newsmlg2::Builder).
    def build_item(klass, **attributes, &)
      Builder.build(klass, attributes, &)
    end

    private

    def store_for(store_or_document)
      if store_or_document.is_a?(CatalogStore)
        store_or_document
      else
        store_or_document.catalog_store
      end
    end
  end

  # Registry: element id -> model class. The single source of truth for
  # root-element dispatch and itemSet item resolution (plurimath/mml
  # pattern); library code never compares element-name strings itself.
  Configuration.register_model(NewsItem, id: :newsItem)
  Configuration.register_model(PackageItem, id: :packageItem)
  Configuration.register_model(ConceptItem, id: :conceptItem)
  Configuration.register_model(KnowledgeItem, id: :knowledgeItem)
  Configuration.register_model(CatalogItem, id: :catalogItem)
  Configuration.register_model(PlanningItem, id: :planningItem)
  Configuration.register_model(NewsMessage, id: :newsMessage)

  # The build_* factory entry points (build_news_item, build_news_message,
  # ...) mirror Builder's registry-generated factories — registering a model
  # above adds its facade method here too.
  Builder.factory_names.each do |factory|
    define_singleton_method(factory) do |**attributes, &block|
      Builder.public_send(factory, **attributes, &block)
    end
  end
end
