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

    class << self
      # Builds any item model and returns a Document.
      def build(klass, attributes = {}, &block)
        attributes = attributes.transform_keys(lang: :xml_lang)
        model = klass.new(attributes)
        Builder::Node.new(model).apply(&block) if block
        Document.new(model)
      end

      def build_news_item(**attributes, &)
        build(Newsmlg2::NewsItem, attributes, &)
      end

      def build_package_item(**attributes, &)
        build(Newsmlg2::PackageItem, attributes, &)
      end

      def build_concept_item(**attributes, &)
        build(Newsmlg2::ConceptItem, attributes, &)
      end

      def build_knowledge_item(**attributes, &)
        build(Newsmlg2::KnowledgeItem, attributes, &)
      end

      def build_catalog_item(**attributes, &)
        build(Newsmlg2::CatalogItem, attributes, &)
      end

      def build_planning_item(**attributes, &)
        build(Newsmlg2::PlanningItem, attributes, &)
      end

      def build_news_message(**attributes, &)
        build(Newsmlg2::NewsMessage, attributes, &)
      end
    end
  end
end
