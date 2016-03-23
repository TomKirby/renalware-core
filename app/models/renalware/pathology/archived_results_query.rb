require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for finding a patient's most recent observations results
    # limited by the number of unique observation dates.
    #
    # Example:
    #
    # Given a patient has results observed on the following dates:
    #
    #     2014/01/01
    #     2015/01/01
    #     2015/01/01
    #     2016/01/01
    #
    # If you specify the limit to `2` then expect three observations returned:
    #
    #     2015/01/01
    #     2015/01/01
    #     2016/01/01
    #
    # Although there are three observations returned, there are only 2 unique dates.
    #
    class ArchivedResultsQuery
      attr_reader :limit

      def initialize(patient:, limit: 20)
        @patient = patient
        @limit = limit
      end

      def call
        observed_at_range = determine_date_range_within_limit
        find_observations_within_range(observed_at_range)
      end

      private

      def determine_date_range_within_limit
        DetermineDateRangeQuery.new(patient: @patient, limit: @limit).call
      end

      def find_observations_within_range(range)
        @patient
          .observations
          .where(observed_at: range)
          .ordered
      end
    end
  end
end
