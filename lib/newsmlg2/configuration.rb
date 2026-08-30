# frozen_string_literal: true

module Newsmlg2
  # Registry of the NewsML-G2 root models in a lutaml-model global context,
  # keyed by element id. This is the single source of truth for
  # element-name → class resolution (root dispatch, itemSet items) —
  # following the plurimath/mml pattern, library code never compares
  # element-name strings itself.
  module Configuration
    CONTEXT_ID = :newsmlg2

    class << self
      def context
        Lutaml::Model::GlobalContext.context(CONTEXT_ID)
      end

      # Rebuilds the built-in context from the registered models.
      def populate_context!
        Lutaml::Model::GlobalContext.unregister_context(CONTEXT_ID) if context
        type_context = Lutaml::Model::GlobalContext.create_context(
          id: CONTEXT_ID,
          registry: Lutaml::Model::TypeRegistry.new,
          fallback_to: [:default]
        )
        register_models_in(type_context)
        Lutaml::Model::GlobalContext.clear_caches
        type_context
      end

      # Registers a model under its element id (see the registration block
      # at the bottom of lib/newsmlg2.rb).
      def register_model(klass, id:)
        normalized_id = id.to_sym
        registered_models[normalized_id] = klass
        (context || populate_context!).registry.register(normalized_id, klass)
        klass
      end

      # Resolves an element name to its registered model class, or nil for
      # unregistered names (non-element nodes, foreign roots).
      def resolve(element_name)
        name = element_name.to_sym
        return nil unless Lutaml::Model::GlobalContext.resolvable?(name, CONTEXT_ID)

        Lutaml::Model::GlobalContext.resolve_type(name, CONTEXT_ID)
      end

      private

      def register_models_in(type_context)
        registered_models.each do |model_id, klass|
          type_context.registry.register(model_id, klass)
        end
      end

      def registered_models
        @registered_models ||= {}
      end
    end
  end
end
