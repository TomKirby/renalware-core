# frozen_string_literal: true

require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class DonorWorkupsController < BaseController
      before_action :load_patient

      def show
        workup = DonorWorkup.for_patient(patient).first_or_initialize
        if workup.new_record?
          redirect_to edit_patient_transplants_donor_workup_path(patient)
        else
          render locals: { patient: patient, workup: workup }
        end
      end

      def edit
        workup = DonorWorkup.for_patient(patient).first_or_initialize
        render locals: { patient: patient, workup: workup }
      end

      def update
        workup = DonorWorkup.for_patient(patient).first_or_initialize

        if workup.update(workup_params)
          redirect_to patient_transplants_donor_workup_path(patient),
            notice: t(".success", model_name: "donor work up")
        else
          flash.now[:error] = t(".failed", model_name: "donor work up")
          render :edit, locals: { patient: patient, workup: workup }
        end
      end

      private

      def workup_params
        params
          .require(:transplants_donor_workup)
          .permit
          .merge(document: document_attributes)
      end

      def document_attributes
        params
          .require(:transplants_donor_workup)
          .fetch(:document, nil).try(:permit!)
      end
    end
  end
end
