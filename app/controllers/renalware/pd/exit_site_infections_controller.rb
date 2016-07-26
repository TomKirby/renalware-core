require_dependency "renalware/pd"

module Renalware
  module PD
    class ExitSiteInfectionsController < BaseController
      include PresenterHelper

      before_action :load_patient, only: [:new, :create, :show, :edit, :update]
      before_action :load_exit_site_infection, only: [:show, :edit, :update]

      def show
        @prescriptions = present(
          @exit_site_infection.prescriptions.ordered,
          Medications::PrescriptionPresenter
        )
        @treatable = present(@exit_site_infection, Medications::TreatablePresenter)
      end

      def new
        @exit_site_infection = ExitSiteInfection.new
      end

      def create
        @exit_site_infection = ExitSiteInfection.new(exit_site_infection_params)
        @exit_site_infection.patient_id = @patient.id
        if @exit_site_infection.save
          redirect_to patient_pd_exit_site_infection_path(@patient, @exit_site_infection),
            notice: t(".success", model_name: "exit site infection")
        else
          flash[:error] = t(".failed", model_name: "exit site infection")
          render :new
        end
      end

      def edit
        render
      end

      def update
        @exit_site_infection.update(exit_site_infection_params)
      end

      private

      def exit_site_infection_params
        params
          .require(:pd_exit_site_infection)
          .permit(:diagnosis_date, :treatment, :outcome, :notes)
      end

      def load_exit_site_infection
        @exit_site_infection = ExitSiteInfection.find(params[:id])
      end
    end
  end
end
