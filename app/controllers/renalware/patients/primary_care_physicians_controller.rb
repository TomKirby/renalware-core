require_dependency "renalware/patients"

module Renalware
  module Patients
    class PrimaryCarePhysiciansController < BaseController
      include Renalware::Concerns::Pageable

      before_action :find_primary_care_physician, only: [:edit, :update]

      def index
        @primary_care_physicians = PrimaryCarePhysician.order(:family_name).page(@page).per(@per_page)
        authorize @primary_care_physicians
      end

      def new
        @primary_care_physician = PrimaryCarePhysician.new
        @alternative_address = alternative_address
        authorize @primary_care_physician
      end

      def edit
        render_form(@primary_care_physician, :edit)
      end

      def create
        @primary_care_physician = PrimaryCarePhysician.new(primary_care_physician_params)
        authorize @primary_care_physician

        if @primary_care_physician.save
          redirect_to patients_primary_care_physicians_path,
            notice: t(".success", model_name: "primary_care_physician")
        else
          @alternative_address = alternative_address
          flash[:error] = t(".failed", model_name: "primary_care_physician")
          render :new
        end
      end

      def update
        if @primary_care_physician.update(primary_care_physician_params)
          update_primary_care_physician_successful(@primary_care_physician)
        else
          update_primary_care_physician_failed(@primary_care_physician)
        end
      end

      def destroy
        authorize PrimaryCarePhysician.destroy(params[:id])

        redirect_to patients_primary_care_physicians_path,
          notice: t(".success", model_name: "primary_care_physician")
      end

      private

      def find_primary_care_physician
        @primary_care_physician = PrimaryCarePhysician.find_or_initialize_by(id: params[:id])
        authorize @primary_care_physician
      end

      def update_primary_care_physician_successful(_primary_care_physician)
        redirect_to_primary_care_physicians_list
      end

      def update_primary_care_physician_failed(primary_care_physician)
        flash[:error] = t(".failed", model_name: "primary_care_physician")
        render_form(primary_care_physician, :edit)
      end

      def redirect_to_primary_care_physicians_list
        redirect_to patients_primary_care_physicians_path, notice: t(".success", model_name: "primary_care_physician")
      end

      def render_form(primary_care_physician, action)
        @primary_care_physician = primary_care_physician
        @alternative_address = alternative_address
        render action
      end

      def primary_care_physician_params
        params.require(:patients_primary_care_physician).permit(
          :given_name, :family_name, :email, :practitioner_type, :code, :telephone, practice_ids: [],
          address_attributes: [
            :id, :name, :organisation_name, :street_1, :street_2, :city, :county, :postcode, :country
          ]
        )
      end

      def alternative_address
        @primary_care_physician.address || @primary_care_physician.build_address
      end
    end
  end
end