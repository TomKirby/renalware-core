require_dependency "renalware/pd"
require_dependency "renalware/success"
require_dependency "renalware/failure"

module Renalware
  module PD
    class ReviseRegime

      def initialize(regime)
        @regime = regime
      end

      def call(by:, params:)
        Regime.transaction do
          regime.assign_attributes(params)
          return ::Renalware::Success.new(regime) unless regime.anything_changed?
          return ::Renalware::Failure.new(regime.with_bag_destruction_marks_removed) unless regime.valid?

          new_regime = revise_regime(by: by)
          ::Renalware::Success.new(new_regime)
        end
      end

      private

      attr_reader :regime

      def revise_regime(by:)
        new_regime = duplicate_original_regime
        terminate_original_regime(by: by, new_regime: new_regime)
        new_regime
      end

      def duplicate_original_regime
        new_regime = regime.deep_dup
        new_regime.save!
        new_regime
      end

      def terminate_original_regime(by:, new_regime:)
        regime.deep_restore_attributes

        if new_regime.start_date >= regime.start_date
          # Without this condition a validation error could result; the down
          # side of this condition is that the end_date of the original regime.
          # could be stuck at Pending.
          regime.end_date ||= new_regime.start_date
        end
        regime.terminate(by: by)
        regime.save!
      end
    end
  end
end
