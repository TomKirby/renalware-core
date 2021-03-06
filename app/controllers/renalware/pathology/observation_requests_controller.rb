# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationRequestsController < Pathology::BaseController
      include Renalware::Concerns::Pageable
      before_action :load_patient

      def index
        observation_requests = find_observation_requests

        render locals: { observation_requests: observation_requests, patient: @patient }
      end

      def show
        observation_request = find_observation_request

        render locals: { observation_request: observation_request, patient: @patient }
      end

      private

      def find_observation_requests
        @patient.observation_requests
          .page(page)
          .includes(:description)
          .ordered
      end

      def find_observation_request
        @patient.observation_requests
          .includes(:description, observations: :description)
          .find(params[:id])
      end
    end
  end
end
