# frozen_string_literal: true

module Newsmlg2
  # The set of catalogs known to one NewsML-G2 document: inline <catalog>
  # elements plus catalogs resolved from <catalogRef> hrefs (IPTC standard
  # catalogs resolve to the files bundled with this gem). Owns scheme alias
  # and URI lookups used for qcode expansion.
  class CatalogStore
    include Enumerable

    def initialize
      @catalogs = []
    end

    attr_reader :catalogs

    def add_catalog(catalog)
      catalogs << catalog
      self
    end
    alias << add_catalog

    def add_catalog_ref(href)
      catalog = Newsmlg2::CatalogCache.load(href)
      add_catalog(catalog) if catalog
    end

    def each(&)
      catalogs.each(&)
    end

    def length
      catalogs.length
    end
    alias size length

    def [](index)
      catalogs[index]
    end

    def get_scheme_for_alias(alias_name)
      schemes.each do |scheme|
        return scheme if scheme.alias_attr == alias_name
      end
      raise AliasNotFoundInCatalogs,
            'no catalog of this document declares the scheme alias ' \
            "'#{alias_name}'"
    end

    def get_scheme_for_uri(uri)
      schemes.each do |scheme|
        return scheme if scheme.uri == uri
      end
      raise UriNotFoundInCatalogs,
            "no catalog of this document declares the scheme URI '#{uri}'"
    end

    # Expands a qcode (e.g. "ninat:text") to its full concept URI.
    #
    # @raise [Newsmlg2::AliasNotFoundInCatalogs]
    def qcode_to_uri(qcode)
      alias_name, code = qcode.split(':', 2)
      raise ArgumentError, "not a qcode: #{qcode.inspect}" if code.nil?

      get_scheme_for_alias(alias_name).uri + code
    end

    # Compresses a concept URI back to a qcode (e.g. "ninat:text").
    #
    # @raise [Newsmlg2::UriNotFoundInCatalogs]
    def uri_to_qcode(uri)
      idx = uri.rindex('/')
      raise ArgumentError, "not a concept URI: #{uri.inspect}" unless idx

      scheme_uri = uri[0..idx]
      code = uri[(idx + 1)..]
      "#{get_scheme_for_uri(scheme_uri).alias_attr}:#{code}"
    end

    def schemes
      catalogs.flat_map(&:schemes)
    end

    def to_s
      "#<Newsmlg2::CatalogStore #{length} catalog(s)>"
    end
  end
end
