module Renalware
  module ClinicHelper
    def link_to_clinic_visit_letter(patient, clinic_visit)
      letter = Letters::Letter.for_event(clinic_visit)
      if letter.present?
        link_to("Preview Letter", patient_letters_letter_path(patient, letter))
      else
        link_to("Draft Letter", new_patient_letters_letter_path(
          @patient,
          event_type: clinic_visit.class.name.to_s, event_id: clinic_visit.id
        ))
      end
    end
  end
end
