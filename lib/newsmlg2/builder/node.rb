# frozen_string_literal: true

require 'date'

module Newsmlg2
  class Builder
    # Wraps one model instance and exposes a DSL method per lutaml-model
    # attribute. One anonymous Node subclass per model class carries the
    # generated methods, defined once at class level — wrapping a model
    # only allocates an instance.
    #
    # NOTE: blocks run under instance_eval, so an unqualified method call
    # inside a block resolves against the node first — if the name matches
    # an attribute (e.g. `version_created(item)`), it becomes a DSL
    # assignment instead of calling a helper from the enclosing scope.
    # Non-coercible values are rejected with ArgumentError; compute values
    # before entering the DSL or call helpers on an explicit receiver.
    class Node
      SCALAR_TYPES = [String, Numeric, Symbol, TrueClass, FalseClass, NilClass,
                      Time, Date, DateTime].freeze

      # Builds and memoizes one anonymous Node subclass per model class,
      # with the DSL methods defined once at class level.
      class ProxyFactory
        class << self
          # The proxy class carrying the DSL methods of one model class.
          def for(model_class)
            proxies[model_class] ||= build(model_class)
          end

          private

          def proxies
            @proxies ||= {}
          end

          def build(model_class)
            proxy = Class.new(Node)
            model_class.attributes.each_key do |name|
              define_attribute_method(proxy, model_class, name)
            end
            proxy
          end

          # The DSL method for one attribute, plus the singular alias when
          # the attribute is a collection (names -> name, keywords ->
          # keyword, libraries -> library — python-newsmlg2 parity).
          def define_attribute_method(proxy, model_class, name)
            return if proxy.method_defined?(name)

            proxy.define_method(name) do |value = UNSET, **attrs, &block|
              set_attribute(name, value, attrs, block)
            end

            singular = singular_of(name)
            return unless singular &&
                          model_class.attributes[name].options[:collection]

            proxy.define_method(singular) do |value = UNSET, **attrs, &block|
              set_attribute(name, value, attrs, block)
            end
          end

          def singular_of(name)
            s = name.to_s
            if s.end_with?('ies')
              "#{s[0..-4]}y"
            elsif s.end_with?('s') && !s.end_with?('ss')
              s[0..-2]
            end
          end
        end
      end

      class << self
        # Routes to the per-model-class proxy; the proxies themselves use
        # the standard allocator.
        def new(model)
          return super unless equal?(Node)

          ProxyFactory.for(model.class).new(model)
        end
      end

      attr_reader :model

      def initialize(model)
        @model = model
      end

      # Runs a block against this node and returns the underlying model.
      def apply(&block)
        instance_eval(&block) if block
        @model
      end

      private

      def set_attribute(name, value, attrs, block)
        validate_value!(name, value) unless value.equal?(UNSET)

        child = build_value(name, value, attrs)
        child = Node.new(child).apply(&block) if block && child.is_a?(NarModel)
        assign(name, child)
        child
      end

      def build_value(name, value, attrs)
        return build_child(name, **attrs) if value.equal?(UNSET)
        return coerce(name, value) if attrs.empty?

        build_child(name, **attrs, text: scalar_text(value))
      end

      # Accepts model instances and scalar/coercible values; anything else
      # (foreign application objects, most commonly an unqualified helper
      # call captured by instance_eval) fails fast here instead of
      # corrupting the model graph and exploding at serialization time.
      def validate_value!(name, value)
        return if coercible_scalar?(value)
        return if value.is_a?(NarModel)

        raise ArgumentError,
              "#{@model.class.name} attribute #{name} cannot assign " \
              "#{value.class} (#{value.inspect[0, 60]}). Builder blocks run " \
              'under instance_eval: an unqualified method call whose name ' \
              'matches an attribute becomes a DSL assignment. Compute the ' \
              'value before entering the block, or call helpers on an ' \
              'explicit receiver.'
      end

      def coercible_scalar?(value)
        SCALAR_TYPES.any? { |type| value.is_a?(type) }
      end

      def scalar_text(value)
        value.is_a?(Time) ? value.strftime('%Y-%m-%dT%H:%M:%S%:z') : value.to_s
      end

      def build_child(name, **attrs)
        type = attribute_type(name)
        raise ArgumentError, "attribute #{name} is a plain value" if type == String

        type.new(**attrs)
      end

      def coerce(name, value)
        type = attribute_type(name)
        return value if type == String || value.nil?
        return value unless coercible_scalar?(value)

        # A scalar assigned to a content-bearing model type wraps into the
        # type's text content (python-newsmlg2's
        # "located.name = 'Berlin'" convenience).
        type.new(text: scalar_text(value))
      end

      def assign(name, child)
        if collection?(name)
          current = @model.send(name)
          if current.nil?
            @model.send(:"#{name}=", [child])
          else
            current << child
          end
        else
          @model.send(:"#{name}=", child)
        end
      end

      def collection?(name)
        @model.class.attributes[name].options[:collection] == true
      end

      def attribute_type(name)
        type = @model.class.attributes[name].type
        type.is_a?(Class) ? type : String
      end
    end
  end
end
