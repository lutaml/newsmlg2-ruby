# frozen_string_literal: true

module Newsmlg2
  # A local or remote catalog: a set of scheme alias-to-URI declarations.
  class Catalog < Newsmlg2::NarModel
    include Newsmlg2::Base::CommonPowerAttributes
    include Newsmlg2::Base::AuthorityAttributes

    xml_attributes additionalinfo: 'additionalInfo', url: 'url',
                   guid: 'guid', version: 'version'
    xml_element :titles, xml: 'title',
                         type: Newsmlg2::Types::Label1Type, collection: true
    xml_element :schemes, xml: 'scheme',
                          type: Newsmlg2::Scheme, collection: true

    xml do
      element 'catalog'
    end

    def get_scheme_for_alias(alias_name)
      schemes.find { |scheme| scheme.alias_attr == alias_name }
    end

    def get_scheme_for_uri(uri)
      schemes.find { |scheme| scheme.uri == uri }
    end

    def length
      schemes.length
    end

    def to_s
      return '<Catalog>' if titles.empty?

      "<Catalog \"#{titles.first}\">"
    end
  end
end
