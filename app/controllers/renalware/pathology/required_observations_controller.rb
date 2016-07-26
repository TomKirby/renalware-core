require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequiredObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
          global_pathology = @patient.required_observation_requests(clinic)
          patient_pathology = @patient.required_patient_pathology
          clinics = Renalware::Clinics::Clinic.ordered
          request_form_options = RequestAlgorithm::FormOptions.new(
            patients: Array(@patient),
            clinic: clinic
          )

          render :index, locals: {
            global_pathology: global_pathology,
            patient_pathology: patient_pathology,
            clinics: clinics,
            clinic: clinic,
            request_form_options: request_form_options
          }
      end

      private

      def clinic
        @clinic ||= begin
          if params[:clinic_id].present?
            Renalware::Clinics::Clinic.find(params[:clinic_id])
          else
            Renalware::Clinics::Clinic.ordered.first
          end
        end
      end
    end
  end
end
