require_dependency "renalware/renal"

module Renalware
  module Renal
    module LowClearance
      class ModalityDescription < Modalities::Description
        def to_sym
          :low_clearance
        end
      end
    end
  end
end