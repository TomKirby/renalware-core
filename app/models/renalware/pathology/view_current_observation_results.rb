require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewCurrentObservationResults
      def initialize(patient, presenter, descriptions: default_descriptions)
        @patient = patient
        @descriptions = descriptions
        @presenter = presenter
      end

      def call(_params = {})
        # Get an array of observations for the requested descriptions
        results = find_current_observations_for_descriptions
        # Although we now have all the observations, they are not in the right order.
        # Hence this sort by description code.
        sorted_results = sort_results(results)
        present(sorted_results)
      end

      private

      def find_current_observations_for_descriptions
        CurrentObservationsForDescriptionsQuery
          .new(patient: @patient, descriptions: @descriptions)
          .call
      end

      def sort_results(results)
        @descriptions.map { |description| find_result_for_description(results, description) }
                     .compact
      end

      def find_result_for_description(results, description)
        results.detect { |result| result.description_code == description.code }
      end

      def present(results)
        @presenter.present(results)
      end

      def default_descriptions
        RelevantObservationDescription.all
      end
    end
  end
end
