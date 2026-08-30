# frozen_string_literal: true

module Newsmlg2
  class Builder
    # Wraps one model instance and exposes a DSL method per lutaml-model
    # attribute. Methods are generated at wrap time from the attribute
    # metadata, so unknown methods fail with a normal NoMethodError.
    class Node
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

      def private_method_defined?(name)
        respond_to?(name, true) && !respond_to?(name)
      end

      def set_attribute(name, value, attrs, block)
        child =
          if attrs.any? && !value.equal?(UNSET)
            build_child(name, **attrs, text: value.to_s)
          elsif attrs.any?
            build_child(name, **attrs)
          elsif !value.equal?(UNSET)
            coerce(name, value)
          else
            build_child(name)
          end

        child = self.class.new(child).apply(&block) if block && child.is_a?(NarModel)
        assign(name, child)
        child
      end

      def build_child(name, **attrs)
        type = attribute_type(name)
        raise ArgumentError, "attribute #{name} is a plain value" if type == String

        type.new(**attrs)
      end

      def coerce(name, value)
        type = attribute_type(name)
        return value if type == String || (!value.is_a?(String) && !value.is_a?(Numeric))

        # A String (or number) assigned to a content-bearing model type
        # wraps into the type's text content (python-newsmlg2's
        # "located.name = 'Berlin'" convenience).
        type.new(text: value.to_s)
      end

      def text_typed?(name)
        type = attribute_type(name)
        type != String
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
        attribute = @model.class.attributes[name]
        attribute.options[:collection] == true
      rescue StandardError
        false
      end

      def attribute_type(name)
        attribute = @model.class.attributes[name]
        type = attribute.type
        type.is_a?(Class) ? type : String
      rescue StandardError
        String
      end
    end
  end
end
