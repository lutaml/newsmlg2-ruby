# frozen_string_literal: true

module Newsmlg2
  # Base class for every NewsML-G2 (NAR namespace) model. Binds the NAR
  # namespace once so subclasses only declare their element name and mappings,
  # and provides the compact declaration DSL (xml_attributes, xml_element,
  # xml_content) used by model classes and Base group mixins alike.
  #
  # Subclass skeleton:
  #   class ItemMeta < Newsmlg2::NarModel
  #     include Base::ItemManagementGroup   # shared XSD element group
  #     xml do
  #       element "itemMeta"                # this class's element name
  #     end
  #   end
  #
  # lutaml-model accumulates xml mappings across included modules, superclass
  # mappings and the class's own xml block, so group mixins merge in include
  # order and serialized child order follows declaration order.
  class NarModel < Lutaml::Model::Serializable
    # Resolve registry symbol types (e.g. ItemSet's :"newsItem") in the
    # Newsmlg2 context for direct from_xml/to_xml calls.
    def self.lutaml_default_register
      Newsmlg2::Configuration::CONTEXT_ID
    end

    xml do
      namespace Newsmlg2::NarNamespace
    end

    class << self
      # Declares string attributes together with their XML attribute
      # mappings. Positional names use the Ruby name as the wire name;
      # keyword pairs map a Ruby name to a different wire name
      # (e.g. class_attr: "class").
      def xml_attributes(*names, **xml_names)
        names.each { |name| xml_string_attribute(name, name.to_s) }
        xml_names.each { |name, xml_name| xml_string_attribute(name, xml_name.to_s) }
      end

      # Declares the W3C xml:lang attribute (BCP 47 language tag).
      def xml_lang_attribute
        attribute :xml_lang, Newsmlg2::Types::XmlLang
        xml { map_attribute 'lang', to: :xml_lang }
      end

      # Declares a child element attribute together with its XML element
      # mapping. +type+ may be a class constant or a lutaml-model type.
      def xml_element(ruby_name, xml: ruby_name.to_s, type: :string, collection: false)
        attribute ruby_name, type, collection: collection
        xml { map_element xml.to_s, to: ruby_name }
      end

      # Declares the element's text-content attribute. Use collection: true
      # for mixed-content models where text interleaves with child elements.
      def xml_content(collection: false)
        attribute :text, :string, collection: collection
        xml { map_content to: :text }
      end

      # The XML element name this class serializes to, or nil for types
      # that only appear as nested children.
      def xml_root_name
        mappings[:xml]&.root_element
      end

      private

      def xml_string_attribute(name, xml_name)
        attribute name, :string
        xml { map_attribute xml_name, to: name }
      end
    end
  end
end
