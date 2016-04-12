require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RecentObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        presenter = ViewRecentObservationsFactory.new.build(@patient).call

        render :index, locals: {
          rows: presenter.present,
          number_of_records: presenter.limit
        }
      end
    end
  end
end
