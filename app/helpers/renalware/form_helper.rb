module Renalware
  module FormHelper
    def errors_css_class(model, attr)
      " field_with_errors" if model.errors.key?(attr)
    end

    def render_input(builder, attribute)
      class_name = builder.object.send(attribute).class.name.demodulize.underscore
      render "renalware/shared/documents/#{class_name}_input", attribute: attribute, f: builder
    end
  end
end
