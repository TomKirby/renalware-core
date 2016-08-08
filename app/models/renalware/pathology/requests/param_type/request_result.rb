require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class RequestResult
          def initialize(patient, param_id, param_comparison_operator, param_comparison_value)
            unless ["==", ">", "<", ">=", "<="].include?(param_comparison_operator)
              raise ArgumentError
            end

            @patient = patient
            @param_id = param_id.to_i
            @param_comparison_operator = param_comparison_operator
            @param_comparison_value = param_comparison_value.to_i
          end

          def required?
            return true if observation_result.nil?
            observation_result.send(@param_comparison_operator.to_sym, @param_comparison_value)
          end

          private

          def observation_result
            @observation_result ||= begin

              observation =
                ::Renalware::Pathology::ObservationForPatientObservationDescriptionQuery.new(
                  @patient, observation_description
                ).call

              observation.result.to_i if observation.present?
            end
          end

          def observation_description
            @observation_description ||=
              Renalware::Pathology::RequestDescription.find(
                @param_id
              ).required_observation_description
          end
        end
      end
    end
  end
end
