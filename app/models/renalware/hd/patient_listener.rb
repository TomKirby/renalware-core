# rubocop:disable Rails/SkipsModelValidations
module Renalware
  module HD
    class PatientListener
      def patient_modality_changed_to_death(patient:, modality:, actor:)
        nullify_significant_hd_profile_attributes(patient, by: actor)
      end

      private

      def nullify_significant_hd_profile_attributes(patient, by:)
        hd_profile = HD.cast_patient(patient).hd_profile
        return if hd_profile.nil?
        hd_profile.hospital_unit = nil
        hd_profile.schedule = nil
        hd_profile.save_by(by)
      end
    end
  end
end