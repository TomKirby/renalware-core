require_dependency "renalware/patients"

module Renalware
  module SideNavHelper
    def display_pd_menu?(patient)
      pd_patient = Renalware::PD.cast_patient(patient)
      pd_patient.treated?
    end

    def display_hd_menu?(patient)
      hd_patient = Renalware::HD.cast_patient(patient)
      hd_patient.treated?
    end

    def find_user_bookmark_for_patient(patient)
      user = Renalware::Patients.cast_user(current_user)
      user.bookmark_for_patient(patient)
    end
  end
end
