# frozen_string_literal: true

module Newsmlg2
  # Resolves catalogRef hrefs to the catalog XML files bundled with this
  # gem (under lib/newsmlg2/catalogs), so resolution never touches the
  # network. The bundled directory is the source of truth for which
  # catalogs resolve; each catalog is parsed once per process and the
  # parsed Catalog is shared across documents (treated as immutable).
  module CatalogCache
    CATALOGS_PATH = File.join(__dir__, 'catalogs')

    # Only IPTC standard catalog URLs resolve; a foreign URL never resolves
    # to a bundled file, even when its basename collides with one.
    IPTC_CATALOG_PREFIX = 'http://www.iptc.org/std/catalog/'

    class << self
      # The bundled file path for a remote catalog URL, or nil when unknown.
      def bundled_path_for(url)
        return nil unless url.is_a?(String) &&
                          url.start_with?(IPTC_CATALOG_PREFIX)

        file = File.basename(url)
        return nil unless bundled_files.include?(file)

        File.join(CATALOGS_PATH, file)
      end

      # Reads the bundled catalog XML for a remote catalog URL, or nil.
      def read(url)
        path = bundled_path_for(url)
        path && File.read(path)
      end

      # Parses the bundled catalog for a remote URL into a Catalog — once
      # per process, shared with every document that references it — or
      # nil when the URL does not resolve.
      def load(url)
        path = bundled_path_for(url)
        return nil unless path

        cache[path] ||= Newsmlg2::Catalog.from_xml(File.read(path))
      end

      private

      def cache
        @cache ||= {}
      end

      # The bundled file names; adding a catalog to the gem is dropping the
      # file into lib/newsmlg2/catalogs — no second list to maintain.
      def bundled_files
        @bundled_files ||= Dir.glob('*.xml', base: CATALOGS_PATH).to_set
      end
    end
  end
end
