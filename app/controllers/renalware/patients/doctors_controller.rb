require_dependency "renalware/patients"

module Renalware
  module Patients
    class DoctorsController < BaseController
      include Renalware::Concerns::Pageable

      before_action :find_doctor, only: [:edit, :update]

      def index
        @doctors = Doctor.order(:family_name).page(@page).per(@per_page)
        authorize @doctors
      end

      def new
        @doctor = Doctor.new
        authorize @doctor
      end

      def edit
        render_form(@doctor, :edit)
      end

      def create
        @doctor = Doctor.new(doctor_params)
        authorize @doctor

        if @doctor.save
          redirect_to patients_doctors_path,
            notice: t(".success", model_name: "doctor")
        else
          flash[:error] = t(".failed", model_name: "doctor")
          render :new
        end
      end

      def update
        if @doctor.update(doctor_params)
          update_doctor_successful(@doctor)
        else
          update_doctor_failed(@doctor)
        end
      end

      def update_doctor_successful(_doctor)
        redirect_to_doctors_list
      end

      def update_doctor_failed(doctor)
        flash[:error] = t(".failed", model_name: "doctor")
        render_form(doctor, :edit)
      end

      def destroy
        authorize Doctor.destroy(params[:id])

        redirect_to patients_doctors_path,
          notice: t(".success", model_name: "doctor")
      end

      private

      def find_doctor
        @doctor = Doctor.find_or_initialize_by(id: params[:id])
        authorize @doctor
      end

      def redirect_to_doctors_list
        redirect_to patients_doctors_path, notice: t(".success", model_name: "doctor")
      end

      def render_form(doctor, action)
        @doctor = doctor
        render action
      end

      def doctor_params
        params.require(:patients_doctor).permit(
          :given_name, :family_name, :email, :practitioner_type, :code, :telephone, practice_ids: [],
          address_attributes: [
            :id, :name, :organisation_name, :street_1, :street_2, :city, :county, :postcode, :country
          ]
        )
      end
    end
  end
end
