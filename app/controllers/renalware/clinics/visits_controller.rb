# Global visits not scoped to a patient
module Renalware
  module Clinics
    class VisitsController < BaseController
      include Renalware::Concerns::Pageable

      before_action :prepare_paging, only: [:index]

      def index
        visits_query = VisitQuery.new(query_params)
        visits = visits_query.call.page(@page).per(@per_page)
        authorize visits

        render locals: {
          visits: visits,
          query: visits_query.search,
          clinics: Clinic.ordered,
          users: User.ordered
        }
      end

      private

      def query_params
        params
          .fetch(:q, {})
          .merge(page: @page, per_page: @per_page)
      end
    end
  end
end