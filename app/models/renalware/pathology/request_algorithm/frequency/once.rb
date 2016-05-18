require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module Frequency
        # NOTE: The Frequency module will only be called if there was a previous observation
        # so an observation is never required if this method gets called.
        class Once < Base
          def exceeds?(_days)
            false
          end

          def once?
            true
          end
        end
      end
    end
  end
end
