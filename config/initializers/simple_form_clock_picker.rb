# frozen_string_literal: true

SimpleForm.setup do |config|
  config.wrappers :horizontal_clockpicker,
                  tag: :div,
                  class: :row,
                  hint_class: :field_with_hint,
                  error_class: :error do |b|

    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :label_wrapper, tag: :div, class: "small-3 columns" do |ba|
      ba.use :label, class: "right inline"
    end

    b.wrapper :right_input_wrapper, tag: :div, class: "small-9 columns" do |ba|
      ba.wrapper :x, tag: :div, class: "row collapse clockpicker-wrapper" do |bc|
        bc.use :prefix_column
        bc.use :input_column
        bc.use :error, wrap_with: { tag: :small, class: [:error, :datepicker_error] }
        bc.use :hint,  wrap_with: { tag: :span, class: :hint }
      end
    end
  end
end
