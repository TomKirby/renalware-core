# frozen_string_literal: true

module Document
  module AttributeInitializer
    class ActiveModel < Base
      def call
        merge_default_value
        yield name, type, options
        add_validation
      end

      private

      def merge_default_value
        options.reverse_merge!(default: type.public_send(:new))
      end

      def add_validation
        attribute_name = name

        # Add validation callback
        klass.validate("#{name}_valid".to_sym)

        # Validation method
        klass.send(:define_method, "#{name}_valid".to_sym) do
          errors.add(attribute_name.to_sym, :invalid) if public_send(attribute_name).invalid?
        end
      end
    end
  end
end
