require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Global
        def initialize(patient, regime)
          raise ArgumentError unless GlobalRuleSet::REGIMES.include?(regime)
          @patient = patient
          @regime = regime
        end

        def required_pathology
          rule_sets
            .select { |rule_set| rule_set.required_for_patient?(@patient) }
            .map { |rule_set| rule_set.observation_description }
            .uniq
        end

        private

        def rule_sets
          GlobalRuleSet.where(regime: @regime)
        end
      end
    end
  end
end
