# frozen_string_literal: true

module Newsmlg2
  # Generic, reflection-driven builder DSL: node methods are generated from
  # each model's lutaml-model attribute metadata, so every current and
  # future Newsmlg2 model is buildable without per-class builder code.
  #
  #   doc = Newsmlg2.build_news_item(guid: "...", lang: "en-GB") do |item|
  #     item.item_meta do |meta|
  #       meta.item_class qcode: "ninat:text"
  #       meta.provider qcode: "nprov:acme" do |p|
  #         p.name "Acme News Agency"
  #       end
  #       meta.version_created "2026-08-30T12:00:00+00:00"
  #     end
  #     item.content_meta do |cm|
  #       cm.urgency 2
  #       cm.headline "Volcano erupts"
  #       cm.subject qcode: "medtop:20000962" do |s|
  #         s.name "Volcano"
  #       end
  #     end
  #   end
  #
  #   doc.to_xml  # => Newsmlg2::Document
  class Builder
    UNSET = Object.new.freeze

    autoload :Node, 'newsmlg2/builder/node'

    # One build_* factory per registered item type, generated from the
    # registry (newsItem -> build_news_item, newsMessage ->
    # build_news_message). Registering a model adds its factory; the
    # registry stays the single source of truth for the item types.
    FACTORIES = Newsmlg2::Configuration.models.to_h { |model_id, klass|
      [:"build_#{Newsmlg2::Configuration.snake(model_id)}", klass]
    }.freeze

    FACTORIES.each do |factory, klass|
      define_singleton_method(factory) do |**attributes, &block|
        build(klass, attributes, &block)
      end
    end

    class << self
      # Builds any item model and returns a Document.
      def build(klass, attributes = {}, &block)
        attributes = attributes.transform_keys(lang: :xml_lang)
        model = klass.new(attributes)
        Builder::Node.new(model).apply(&block) if block
        Document.new(model)
      end

      # The generated factory method names (one per registered item type).
      def factory_names
        FACTORIES.keys
      end
    end
  end
end
