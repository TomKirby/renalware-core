require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrugType
          def initialize(patient, param_id, _param_comparison_operator, _param_comparison_value)
            @patient = patient
            @param_id = param_id.to_i
          end

          def required?
            @patient.drugs.flat_map(&:drug_types).include?(drug_type)
          end

          private

          def drug_type
            @drug_type ||= Renalware::Drugs::Type.find(@param_id)
          end
        end
      end
    end
  end
end
