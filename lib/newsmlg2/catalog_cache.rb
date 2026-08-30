# frozen_string_literal: true

module Newsmlg2
  # Maps remote IPTC catalog URLs to the catalog XML files bundled with this
  # gem (under lib/newsmlg2/catalogs), so catalogRef resolution never touches
  # the network.
  module CatalogCache
    CATALOGS_PATH = File.join(__dir__, 'catalogs')

    URL_TO_FILE = {
      'http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_32.xml' => 'catalog.IPTC-G2-Standards_32.xml',
      'http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_33.xml' => 'catalog.IPTC-G2-Standards_33.xml',
      'http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_34.xml' => 'catalog.IPTC-G2-Standards_34.xml',
      'http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_35.xml' => 'catalog.IPTC-G2-Standards_35.xml',
      'http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_36.xml' => 'catalog.IPTC-G2-Standards_36.xml',
      'http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_37.xml' => 'catalog.IPTC-G2-Standards_37.xml',
      'http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_38.xml' => 'catalog.IPTC-G2-Standards_38.xml',
      'http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_39.xml' => 'catalog.IPTC-G2-Standards_39.xml',
      'http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_40.xml' => 'catalog.IPTC-G2-Standards_40.xml',
      'http://www.iptc.org/std/catalog/catalog.IPTC-G2-Standards_41.xml' => 'catalog.IPTC-G2-Standards_41.xml'
    }.freeze

    class << self
      # The bundled file path for a remote catalog URL, or nil when unknown.
      def bundled_path_for(url)
        file = URL_TO_FILE[url]
        return nil unless file

        File.join(CATALOGS_PATH, file)
      end

      # Reads the bundled catalog XML for a remote catalog URL, or nil.
      def read(url)
        path = bundled_path_for(url)
        return nil unless path

        File.read(path)
      end

      # Parses the bundled catalog for a remote URL into a Catalog.
      def load(url)
        xml = read(url)
        return nil unless xml

        Newsmlg2::Catalog.from_xml(xml)
      end
    end
  end
end
