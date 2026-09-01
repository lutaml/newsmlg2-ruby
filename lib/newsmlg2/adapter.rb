# frozen_string_literal: true

module Newsmlg2
  # Adapter resolution policy: runs a unit of XML work under the consumer's
  # configured adapter, falling back to the stdlib REXML adapter when the
  # configured one cannot be resolved (fresh install) — the gem never
  # depends on a specific parser and never permanently mutates the
  # consumer's configuration.
  module Adapter
    module_function

    def with_resolved(&)
      Lutaml::Model::Config.adapter_for(:xml)
      yield
    rescue Lutaml::Model::UnknownAdapterTypeError, LoadError
      rexml_fallback(&)
    rescue ArgumentError => e
      # lutaml-model raises a plain ArgumentError for an unknown adapter on
      # its eager-validation path; any other ArgumentError is a real bug.
      raise unless e.message.include?('Unknown adapter')

      rexml_fallback(&)
    end

    def rexml_fallback(&)
      Lutaml::Model::Config.with_adapter(xml: :rexml, &)
    end
  end
end
