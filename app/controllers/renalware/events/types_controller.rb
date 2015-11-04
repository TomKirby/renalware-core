require_dependency "renalware/events"

module Renalware
  module Events
    class TypesController < BaseController
      before_action :load_event_type, only: [:edit, :update]

      def new
        @event_type = Type.new
        authorize @event_type
      end

      def create
        @event_type = Type.new(allowed_params)
        authorize @event_type

        if @event_type.save
          redirect_to events_types_path,
            notice: "You have successfully added a new patient event type."
        else
          render :new
        end
      end

      def index
        @event_types = Type.all
        authorize @event_types
      end

      def update
        if @event_type.update(allowed_params)
          redirect_to events_types_path,
            notice: "You have successfully updated patient event type"
        else
          render :edit
        end
      end

      def destroy
        authorize Type.destroy(params[:id])
        redirect_to events_types_path,
          notice: "You have successfully removed a patient event type."
      end

      private

      def allowed_params
        params.require(:event_type).permit(:name, :deleted_at)
      end

      def load_event_type
        @event_type = Type.find(params[:id])
        authorize @event_type
      end
    end
  end
end