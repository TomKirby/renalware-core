require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RecentObservationResultsController < Pathology::BaseController
      before_action :load_patient

      def index
        table_view = RecentObservationResults::HTMLTableView.new(view_context)
        presenter = RecentObservationResults::Presenter.new
        service = ViewObservationResults.new(@patient.observations, presenter)
        service.call(params)

        render :index, locals: {
          rows: presenter.view_model,
          paginator: presenter.paginator,
          table: table_view
        }
      end
    end
  end
end
