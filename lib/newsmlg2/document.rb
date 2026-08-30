# frozen_string_literal: true

require 'nokogiri'

module Newsmlg2
  # The NewsML-G2 document entry point: parses XML into a typed item (or
  # newsMessage), exposes it, and serializes back to XML. Each document owns
  # its CatalogStore, built from inline catalogs and catalogRefs.
  #
  #   doc = Newsmlg2.parse(xml)      # or Newsmlg2.parse_file(path)
  #   doc.item                       # => Newsmlg2::NewsItem
  #   doc.item.content_meta.headlines.first
  #   doc.catalog_store.get_scheme_for_alias("ninat")
  #   doc.to_xml                     # => declaration + item XML
  class Document
    ROOT_ITEM_CLASSES = {
      'newsItem' => 'Newsmlg2::NewsItem',
      'packageItem' => 'Newsmlg2::PackageItem',
      'conceptItem' => 'Newsmlg2::ConceptItem',
      'knowledgeItem' => 'Newsmlg2::KnowledgeItem',
      'catalogItem' => 'Newsmlg2::CatalogItem',
      'planningItem' => 'Newsmlg2::PlanningItem',
      'newsMessage' => 'Newsmlg2::NewsMessage'
    }.freeze

    class << self
      # The root element name -> class map used for dispatch.
      def item_classes
        ROOT_ITEM_CLASSES.transform_values { |name| Object.const_get(name) }
      end

      # Parses NewsML-G2 XML into a Document.
      def parse(xml)
        root_name = root_element_name(xml)
        klass = ROOT_ITEM_CLASSES[root_name]
        unless klass
          raise UnknownRootElement,
                "'#{root_name}' is not a NewsML-G2 item or newsMessage root element"
        end

        item = Object.const_get(klass).from_xml(xml)
        new(item)
      end

      # Parses a NewsML-G2 XML file into a Document.
      def parse_file(path)
        parse(File.read(path))
      end

      # Parses the item elements carried inside a newsMessage itemSet
      # (raw-captured content) into typed items.
      def parse_item_set_content(content)
        return [] if content.to_s.strip.empty?

        fragment = Nokogiri::XML::DocumentFragment.parse(content.to_s)
        by_name = item_classes
        fragment.children.filter_map do |node|
          next unless node.element?

          klass = by_name[node.name]
          klass&.from_xml(node.to_xml)
        end
      end

      private

      def root_element_name(xml)
        stripped = xml.gsub(/<!--.*?-->/m, '')
        stripped[/\A\s*(?:<\?[^>]*\?>\s*)?<(?:[\w-]+:)?([\w-]+)/, 1] ||
          stripped[%r{\A\s*(?:<\?[^>]*\?>\s*)?<([^\s>/]+)}, 1].to_s
      end
    end

    attr_reader :item

    # @param item [Newsmlg2::AnyItem, Newsmlg2::NewsMessage]
    def initialize(item = nil)
      @item = item
      @catalog_store = CatalogStore.new
      load_catalogs
    end

    # Replaces the document's item and rebuilds its catalog store.
    def item=(new_item)
      unless new_item.is_a?(AnyItem) || new_item.is_a?(NewsMessage)
        raise ArgumentError,
              "expected a Newsmlg2 item or NewsMessage, got #{new_item.class}"
      end

      @item = new_item
      @catalog_store = CatalogStore.new
      load_catalogs
    end

    # The catalogs known to this document (inline catalogs plus catalogRefs
    # resolvable through the bundled IPTC catalog cache).
    def catalog_store
      @catalog_store ||= CatalogStore.new.tap { |store| load_catalogs_into(store) }
    end

    # Serializes the document: XML declaration plus the item, validating that
    # a guid is present (items only).
    def to_xml(**options)
      item.validate! if item.is_a?(AnyItem)
      item.to_xml({ declaration: true }.merge(options))
    end
    alias to_xml_string to_xml

    private

    def load_catalogs
      load_catalogs_into(catalog_store)
    end

    def load_catalogs_into(store)
      return unless item

      case item
      when AnyItem then load_catalog_holders(store, item)
      when NewsMessage then load_catalog_holders(store, item.header)
      end
    end

    def load_catalog_holders(store, holder)
      return unless holder

      holder.catalogs.to_a.each { |catalog| store.add_catalog(catalog) }
      holder.catalog_refs.to_a.each { |ref| store.add_catalog_ref(ref.href) }
    end
  end
end
