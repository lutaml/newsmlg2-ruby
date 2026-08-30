# frozen_string_literal: true

module Newsmlg2
  module Types
    # xml:base attribute values (base URIs).
    class XmlBase < Lutaml::Model::Type::String
      xml do
        namespace Lutaml::Xml::W3c::XmlNamespace
      end
    end
  end
end
