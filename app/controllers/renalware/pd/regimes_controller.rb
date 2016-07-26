require_dependency "renalware/pd"

module Renalware
  module PD
    class RegimesController < BaseController
      include Renalware::Concerns::NestedActionsControllerMethods

      before_action :load_patient
      before_action :find_pd_regime, only: [:edit, :update, :show]

      def new
        regime_type = params[:type] ? "Renalware::#{params[:type]}" : nil
        @pd_regime = @patient.pd_regimes.new(type: regime_type)
      end

      def create
        @pd_regime = @patient.pd_regimes.new(pd_regime_params)
        if perform_action(pd_regime_bags, Proc.new { @pd_regime.save }, regime: @pd_regime)
          redirect_to patient_pd_dashboard_path(@patient),
            notice: t(".success", model_name: "PD regime")
        else
          flash[:error] = t(".failed", model_name: "PD regime")
          render :new
        end
      end

      def update
        action_performed = perform_action(
          pd_regime_bags,
          Proc.new { @pd_regime.update(pd_regime_params) },
          regime: @pd_regime
        )

        if action_performed
          redirect_to patient_pd_dashboard_path(@patient),
            notice: t(".success", model_name: "PD regime")
        else
          flash[:error] = t(".failed", model_name: "PD regime")
          render :edit
        end
      end

      private

      def pd_regime_params
        params.require(:pd_regime).permit(
          :start_date, :end_date, :treatment, :type, :glucose_ml_percent_1_36,
          :glucose_ml_percent_2_27, :glucose_ml_percent_3_86, :amino_acid_ml,
          :icodextrin_ml, :low_glucose_degradation, :low_sodium, :add_hd, :last_fill_ml,
          :add_manual_exchange, :tidal_indicator, :tidal_percentage, :no_cycles_per_apd,
          :overnight_pd_ml,
          regime_bags_attributes: [
            :id, :regime_id, :bag_type_id, :volume, :per_week, :monday, :tuesday,
            :wednesday, :thursday, :friday, :saturday, :sunday, :_destroy]
        )
      end

      def find_pd_regime
        @pd_regime = Regime.find(params[:id])
      end

      def pd_regime_bags
        @pd_regime.regime_bags
      end
    end
  end
end