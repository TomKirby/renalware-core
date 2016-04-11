require "rails_helper"

module Renalware
  module Pathology
    RSpec.describe DetermineDateRangeQuery do
      describe "#call" do
        it "returns the range for the specified limit" do
          patient = create_patient

          create_observations_observed_at(
            patient, "2014-01-01", "2016-01-01", "2015-01-01", "2016-01-01", "2013-01-1"
          )

          query = DetermineDateRangeQuery.new(limit: 3)
          relation = query.call

          expect(relation.map(&observed_at)).to eq(["2016-01-01", "2016-01-01", "2015-01-01"])
        end
      end

      def observed_at
        -> (observation) { observation.observed_at.to_date.strftime("%Y-%m-%d") }
      end

      def create_patient
        patient = create(:patient)
        Pathology.cast_patient(patient)
      end

      def create_observations_observed_at(patient, *observation_dates)
        observation_dates.each do |observed_on|
          request = create(:pathology_observation_request, patient: patient)
          create(:pathology_observation, request: request, observed_at: observed_on)
        end
      end
    end
  end
end
