module Renalware
  module DeviseHelper
    def custom_devise_error_messages!
      return "" if resource.errors.empty?

      messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
      sentence = I18n.t("errors.messages.not_saved",
                        :count => resource.errors.count,
                        :resource => resource.class.model_name.human.downcase)

      html = <<-HTML
      <ul class="error-messages">#{messages}</ul>
      HTML

      html.html_safe
    end

    def devise_error_messages?
      resource.errors.empty? ? false : true
    end
  end
end