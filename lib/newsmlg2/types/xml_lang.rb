# frozen_string_literal: true

module Newsmlg2
  module Types
    # xml:lang attribute values (RFC 5646 language tags).
    class XmlLang < Lutaml::Model::Type::String
      xml do
        namespace Lutaml::Xml::W3c::XmlNamespace
      end
    end
  end
end
