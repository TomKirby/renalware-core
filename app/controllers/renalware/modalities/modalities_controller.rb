require_dependency "renalware/deaths"

module Renalware
  module Modalities
    class ModalitiesController < BaseController

      before_filter :load_patient

      def new
        @modality = Modality.new(patient: patient)
      end

      def index
        @modalities = patient.modalities.ordered
      end

      def create
        @modality = patient.set_modality(modality_params)

        if @modality.valid?
          handle_valid_modality
        else
          flash[:error] = t(".failed", model_name: "modality")
          render :new
        end
      end

      private

      def modality_params
        params.require(:modality).permit(
          :description_id, :modal_change_type,
          :reason_id, :notes, :started_on
        )
      end

      def handle_valid_modality
        if patient.modality_description.is_a? Deaths::ModalityDescription
          redirect_to edit_patient_death_path(patient), flash: {
              warning: "Please make sure to update patient date of death and cause of death!"
            }
        elsif patient.modality_description.is_a? Transplants::DonorModalityDescription
          redirect_to new_patient_transplants_donation_path(patient), flash: {
              warning: "If you have the information on-hand, please enter the potential donation."
            }
        else
          redirect_to patient_modalities_path(patient),
            notice: t(".success", model_name: "modality")
        end
      end
    end
  end
end
