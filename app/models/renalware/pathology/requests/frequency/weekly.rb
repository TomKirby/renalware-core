# frozen_string_literal: true

require_dependency "renalware/pathology/requests/frequency"

module Renalware
  module Pathology
    module Requests
      class Frequency::Weekly < Frequency
        def observation_required?(last_observed_on)
          last_observed_on > 5
        end
      end
    end
  end
end
