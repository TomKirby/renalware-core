module Renalware
  module Transplants
    class RecipientWorkupsController < BaseController
      load_and_authorize_resource class: Renalware::Transplants::RecipientWorkup
      before_filter :load_patient

      def show
        @workup = RecipientWorkup.for_patient(@patient).first_or_initialize
        redirect_to edit_patient_transplants_recipient_workup_path(@patient) if @workup.new_record?
      end

      def edit
        @workup = RecipientWorkup.for_patient(@patient).first_or_initialize
      end

      def update
        @workup = RecipientWorkup.for_patient(@patient).first_or_initialize

        if @workup.update_attributes(workup_params)
          redirect_to patient_transplants_recipient_workup_path(@patient)
        else
          render :edit
        end
      end

      protected

      def workup_params
        document_attributes = params.require(:transplants_recipient_workup)
          .fetch(:document, nil).try(:permit!)
        params.require(:transplants_recipient_workup).permit.merge(document: document_attributes)
      end
    end
  end
end
