require_dependency "renalware/hospitals"

module Renalware
  module Hospitals
    class UnitsController < BaseController
      before_action :load_hospital_unit, only: [:edit, :update]

      def new
        @hospital_unit = Unit.new
        authorize @hospital_unit
      end

      def create
        @hospital_unit = Unit.new(hospital_unit_params)
        authorize @hospital_unit

        if @hospital_unit.save
          redirect_to hospitals_units_path,
            notice: t(".success", model_name: "hospital unit")
        else
          flash.now[:error] = t(".failed", model_name: "hospital unit")
          render :new
        end
      end

      def index
        @hospital_units = Unit.all
        authorize @hospital_units
      end

      def update
        if @hospital_unit.update(hospital_unit_params)
          redirect_to hospitals_units_path,
            notice: t(".success", model_name: "hospital unit")
        else
          flash.now[:error] = t(".failed", model_name: "hospital unit")
          render :edit
        end
      end

      def destroy
        authorize Unit.destroy(params[:id])
        redirect_to hospitals_units_path,
          notice: t(".success", model_name: "hospital unit")
      end

      private

      def hospital_unit_params
        params.require(:hospitals_unit).permit(
          :name, :unit_code, :renal_registry_code, :unit_type, :hospital_centre_id, :is_hd_site
        )
      end

      def load_hospital_unit
        @hospital_unit = Unit.find(params[:id])
        authorize @hospital_unit
      end
    end
  end
end
