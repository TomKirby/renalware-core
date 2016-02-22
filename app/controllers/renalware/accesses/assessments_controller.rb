module Renalware
  module Accesses
    class AssessmentsController < BaseController
      before_filter :load_patient

      def index
      end

      def show
        assessment = Assessment.for_patient(@patient).find(params[:id])
        @assessment = AssessmentPresenter.new(assessment)
      end

      def new
        @assessment = AssessmentFactory.new(patient: @patient).build
      end

      def create
        @assessment = Assessment.new(patient: @patient)
        @assessment.attributes = assessment_params

        if @assessment.save
          redirect_to patient_accesses_dashboard_path(@patient),
            notice: t(".success", model_name: "Access assessment")
        else
          flash[:error] = t(".failed", model_name: "Access assessment")
          render :new
        end
      end

      def edit
        @assessment = Assessment.for_patient(@patient).find(params[:id])
      end

      def update
        @assessment = Assessment.for_patient(@patient).find(params[:id])
        @assessment.attributes = assessment_params

        if @assessment.save
          redirect_to patient_accesses_dashboard_path(@patient),
            notice: t(".success", model_name: "Access assessment")
        else
          flash[:error] = t(".failed", model_name: "Access assessment")
          render :edit
        end
      end

      protected

      def assessment_params
        params.require(:accesses_assessment)
          .permit(attributes)
          .merge(document: document_attributes, by: current_user)
      end

      def attributes
        [
          :performed_on, :first_used_on, :failed_on,
          :site_id, :side, :type_id,
          :catheter_make, :catheter_lot_no,
          :performed_by_id, :notes, :outcome,
          document: []
        ]
      end

      def document_attributes
        params.require(:accesses_assessment)
         .fetch(:document, nil).try(:permit!)
      end
    end
  end
end