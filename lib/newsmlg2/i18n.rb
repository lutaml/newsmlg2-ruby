# frozen_string_literal: true

module Newsmlg2
  # Helpers for multi-language content collections (elements carrying
  # xml:lang, such as ConceptNameType values).
  module I18n
    module_function

    # The languages used by a collection of localized elements.
    def languages(collection)
      collection.filter_map(&:xml_lang).uniq
    end

    # The first element of the collection matching the given language tag
    # (exact match), or nil.
    def for_language(collection, lang)
      collection.find { |item| item.xml_lang == lang }
    end
  end
end
