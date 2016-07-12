require_dependency "renalware/modalities"
require_dependency "renalware/transplants"
require_dependency "renalware/deaths"

module Renalware
  module Modalities
    class ModalitiesController < BaseController

      before_filter :load_patient

      def new
        @modality = Modality.new(patient: @patient)
      end

      def index
        @modalities = @patient.modalities.with_deleted.ordered
      end

      def create
        @modality = @patient.set_modality(modality_params)

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
        if deaths_modality_description(@patient.modality_description).death?
          redirect_to edit_patient_death_path(@patient), flash: {
              warning: "Please make sure to update patient date of death and cause of death!"
            }
        elsif transplant_modality_description(@patient.modality_description).donation?
          redirect_to new_patient_transplants_donation_path(@patient), flash: {
              warning: "If you have the information on-hand, please enter the potential donation."
            }
        else
          redirect_to patient_modalities_path(@patient),
            notice: t(".success", model_name: "modality")
        end
      end

      def transplant_modality_description(modality_description)
        Transplants.cast_modality_description(modality_description)
      end

      def deaths_modality_description(modality_description)
        Deaths.cast_modality_description(modality_description)
      end
    end
  end
end
