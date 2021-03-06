# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationsController < Pathology::BaseController
      include Renalware::Concerns::Pageable
      before_action :load_patient

      def index
        description = find_description
        observations = find_observations_for_description(description)

        render locals: { patient: @patient, observations: observations, description: description }
      end

      private

      def find_description
        ObservationDescription.find(params[:description_id])
      end

      def find_observations_for_description(description)
        @patient.observations
          .page(page)
          .includes(:request)
          .for_description(description)
          .ordered
      end
    end
  end
end
