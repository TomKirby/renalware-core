# frozen_string_literal: true

class SimpleTimeInput < SimpleForm::Inputs::StringInput
  def input(_wrapper_options)
    template.content_tag(:div, class: "row collapse datepicker-wrapper") do
      template.concat prefix_column
      template.concat input_column
    end
  end

  def prefix_column
    template.content_tag(:div, class: "large-2 columns") do
      template.concat icon_clock
    end
  end

  def input_column
    html_options = input_html_options
    html_options[:class] ||= []
    template.content_tag(:div, class: "large-10 columns") do
      time = @builder.object.public_send(attribute_name)
      value = time.present? ? I18n.l(time, format: :time) : ""
      template.concat @builder.text_field(attribute_name, html_options.merge(value: value))
    end
  end

  def icon_clock
    "<span class='prefix'><i class='fa fa-clock-o'></i></span>".html_safe
  end

  def input_type
    :string
  end
end
