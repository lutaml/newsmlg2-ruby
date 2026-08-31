# frozen_string_literal: true

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
  #
  # Root dispatch and itemSet resolution go through the Configuration
  # registry; all model parsing is lutaml-model's from_xml. The gem never
  # references a specific XML parser — the adapter is the consumer's
  # choice via Lutaml::Model::Config.
  class Document
    class << self
      # Parses NewsML-G2 XML into a Document.
      def parse(xml)
        with_resolved_adapter do
          root_name, klass = root_class(xml)
          unless klass
            raise UnknownRootElement,
                  "'#{root_name}' is not a NewsML-G2 item or newsMessage root element"
          end

          new(klass.from_xml(xml))
        end
      end

      # Parses a NewsML-G2 XML file into a Document.
      def parse_file(path)
        parse(File.read(path))
      end

      private

      # Runs the block with the consumer's configured XML adapter; if none
      # resolves (fresh install, unconfigured default), falls back to the
      # REXML adapter, which ships with Ruby — the gem never depends on a
      # specific parser.
      def with_resolved_adapter(&)
        Lutaml::Model::Config.adapter_for(:xml)
        yield
      rescue Lutaml::Model::UnknownAdapterTypeError, LoadError
        Lutaml::Model::Config.with_adapter(xml: :rexml, &)
      end

      # NewsML-G2 has eight possible root elements and lutaml-model has no
      # multi-root dispatch, so the document's root element name is read
      # once through the configured adapter and resolved to its registered
      # model class. No element-name strings live in this file — the
      # registry (lib/newsmlg2.rb registration block) is the single source
      # of truth.
      def root_class(xml)
        root = Lutaml::Model::Config.adapter_for(:xml).parse(xml).root
        return ['', nil] unless root

        name = root.name.sub(/\A[\w.-]+:/, '')
        [name, Configuration.resolve(name)]
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
