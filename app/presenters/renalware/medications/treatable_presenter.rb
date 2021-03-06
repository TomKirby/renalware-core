# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    class TreatablePresenter < DumbDelegator
      def sortable?
        is_a?(Patient)
      end
    end
  end
end
