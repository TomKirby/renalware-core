module Renalware
  class BagTypesController < BaseController

    before_action :load_bag_type, only: [:edit, :update]

    def new
      @bag_type = BagType.new
      authorize @bag_type
    end

    def create
      @bag_type = BagType.new(bag_type_params)
      authorize @bag_type
      if @bag_type.save
        redirect_to bag_types_path, :notice => "You have successfully created a new bag type."
      else
        render :new
      end
    end

    def index
      @bag_types = BagType.all
      authorize @bag_type
    end

    def update
      if @bag_type.update(bag_type_params)
        redirect_to bag_types_path, :notice => "You have successfully updated a bag type"
      else
        render :edit
      end
    end

    def destroy
      authorize BagType.destroy(params[:id])
      redirect_to bag_types_path, :notice => "You have successfully removed a bag type."
    end

    private
    def bag_type_params
      params.require(:bag_type).permit(:manufacturer, :description, :glucose_grams_per_litre, :amino_acid, :icodextrin,
        :low_glucose_degradation, :low_sodium, :sodium_mmole_l, :lactate_mmole_l, :bicarbonate_mmole_l, :calcium_mmole_l, :magnesium_mmole_l)
    end

    def load_bag_type
      @bag_type = BagType.find(params[:id])
      authorize @bag_type
    end
  end
end