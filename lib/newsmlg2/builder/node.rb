# frozen_string_literal: true

require 'date'

module Newsmlg2
  class Builder
    # Wraps one model instance and exposes a DSL method per lutaml-model
    # attribute. Methods are generated at wrap time from the attribute
    # metadata, so unknown methods fail with a normal NoMethodError.
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

      def initialize(model)
        @model = model
        define_attribute_methods
      end

      attr_reader :model

      # Runs a block against this node and returns the underlying model.
      def apply(&block)
        instance_eval(&block) if block
        @model
      end

      private

      def define_attribute_methods
        @model.class.attributes.each_key do |name|
          next if respond_to?(name, false) || respond_to?(name)

          define_singleton_method(name) do |value = UNSET, **attrs, &block|
            set_attribute(name, value, attrs, block)
          end

          singular = singular_of(name)
          next unless singular && collection?(name)

          define_singleton_method(singular) do |value = UNSET, **attrs, &block|
            set_attribute(name, value, attrs, block)
          end
        end
      end

      # python-newsmlg2 parity: singular accessor appending to a plural
      # collection attribute (names -> name, keywords -> keyword,
      # libraries -> library).
      def singular_of(name)
        s = name.to_s
        if s.end_with?('ies')
          "#{s[0..-4]}y"
        elsif s.end_with?('s') && !s.end_with?('ss')
          s[0..-2]
        end
      end

      def set_attribute(name, value, attrs, block)
        validate_value!(name, value) unless value.equal?(UNSET)

        child = build_value(name, value, attrs)
        child = self.class.new(child).apply(&block) if block && child.is_a?(NarModel)
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
