module Renalware
  module LettersHelper
    def patient_letters_letters_path(patient, event=nil)
      if event.present?
        super(patient, event_type: event.class.to_s, event_id: event.id)
      else
        super(patient)
      end
    end

    def inline_value(label, value, unit=nil)
      [
        content_tag(:strong, "#{label}: "),
        value,
        unit
      ].flatten.join(" ").html_safe
    end

    def patient_letters_letter_print_path(letter)
      patient_letters_letter_formatted_path(letter.patient, letter, format: "pdf", disposition: "inline")
    end

    def patient_letters_letter_download_path(letter)
      patient_letters_letter_formatted_path(letter.patient, letter, format: "pdf")
    end

    def patient_letters_letter_preview_path(letter)
      patient_letters_letter_formatted_path(letter.patient, letter)
    end
  end
end

