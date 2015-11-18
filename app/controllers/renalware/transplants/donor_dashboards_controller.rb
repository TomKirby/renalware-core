module Renalware
  module Transplants
    class DonorDashboardsController < BaseController
      before_filter :load_patient

      def show
        @donor_operations = DonorOperation.for_patient(@patient).reversed
      end
    end
  end
end
