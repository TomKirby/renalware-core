class ClockPickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    template.content_tag(:div, class: "row collapse #{class_name}-wrapper") do
      template.concat prefix_column
      template.concat input_column
    end
  end

  def prefix_column
    template.content_tag(:div, class: "large-4 columns") do
      template.concat icon_clock
    end
  end

  def input_column
    html_options = input_html_options
    html_options[:class] ||= []
    html_options[:class] << class_name
    template.content_tag(:div, class: "large-8 columns") do
      datestamp = @builder.object.public_send(attribute_name)
      value = datestamp.present? ? I18n.l(datestamp, format: :time) : ""
      template.concat @builder.text_field(attribute_name, html_options.merge(value: value))
    end
  end

  def icon_clock
    "<span class='prefix'><i class='fi-clock'></i></span>".html_safe
  end

  def input_type
    :string
  end

  def class_name
    "clockpicker"
  end
end