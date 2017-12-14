# rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/ModuleLength
require "array_stringifier"

module World
  module Pathology
    module Domain
      # @section helpers
      #

      # Convert "5 days ago" to a Time object
      def str_to_time(last_observed_at)
        return nil if last_observed_at.nil?

        last_tested_matches =
          last_observed_at.match(/^(?<num>\d+) (?<time_unit>day|days|week|weeks) ago$/)

        if last_tested_matches
          last_tested_matches[:num].to_i.public_send(last_tested_matches[:time_unit]).ago
        end
      end

      # @section commands

      def record_observations(patient:, observations_attributes:)
        patient = Renalware::Pathology.cast_patient(patient)

        observations_attributes.map! { |attrs|
          code = attrs.fetch("code")
          description = Renalware::Pathology::ObservationDescription.find_by(code: code)
          result = attrs.fetch("result")
          observed_at = Time.zone.parse(attrs.fetch("observed_at"))

          { description: description, result: result, observed_at: observed_at }
        }

        Renalware::Pathology::ObservationRequest.create!(
          patient: patient,
          requestor_name: "KCH",
          requested_at: Time.zone.now,
          description: Renalware::Pathology::RequestDescription.first!,
          observations_attributes: observations_attributes
        )
      end

      def create_observation(request:, description_code:, observed_at:)
        description = Renalware::Pathology::ObservationDescription.find_by(code: description_code)

        Renalware::Pathology::Observation.create!(
          request: request,
          description: description,
          observed_at: observed_at,
          result: "100"
        )
      end

      # @section expectations
      #
      def expect_observation_request_to_be_created(attrs)
        observation_request = find_last_observation_request

        expect_attributes_to_match(observation_request, attrs)
      end

      def expect_observations_to_be_created(rows)
        observation_request = find_last_observation_request

        expect(observation_request.observations.count).to eq(rows.size)
        expect_rows_to_match(observation_request.observations, rows)
      end

      # rubocop:disable Rails/TimeZone
      def expect_current_observations_to_be(patient:, rows:)
        patient = Renalware::Pathology.cast_patient(patient)
        observation_set = patient.current_observation_set
        rows.each do |row|
          code = row["code"]
          obs_set = observation_set.values[code]

          expect(obs_set[:result]).to eq(row["result"])
          # Some fancy footwork to get dates to compare
          expected_observed_at = I18n.l(Time.parse(row["observed_at"]))
          actual_observed_at = I18n.l(Time.parse(obs_set[:observed_at]))
          expect(actual_observed_at).to eq(expected_observed_at)
        end
      end
      # rubocop:enable Rails/TimeZone

      def expect_rows_to_match(observations, rows)
        rows.each do |attrs|
          description_code = attrs.fetch("description")
          observation = find_observation(observations, description_code)

          expect_attributes_to_match(observation, attrs)
        end
      end

      def expect_attributes_to_match(record, expected_attrs)
        expected_attrs.each do |attr_name, expected_value|
          actual_value = record.public_send(attr_name).to_s
          expect(actual_value).to eq(expected_value)
        end
      end

      def expect_pathology_recent_observations(user:, patient:, rows:)
        patient = Renalware::Pathology.cast_patient(patient)
        codes = rows.slice(2..-1).map(&:first)
        descriptions = Renalware::Pathology::ObservationDescription.for(codes)

        presenter = Renalware::Pathology::RecentObservationResults::Presenter.new
        service = Renalware::Pathology::ViewObservationResults.new(
          patient.observations, presenter, descriptions: descriptions)
        service.call
        view = ArrayStringifier.new(presenter.view_model).to_a

        expect(view).to match_array(rows)
      end

      def expect_pathology_historical_observations(user:, patient:, rows:)
        patient = Renalware::Pathology.cast_patient(patient)
        codes = rows.first[1..-1]
        descriptions = Renalware::Pathology::ObservationDescription.for(codes)

        presenter = Renalware::Pathology::HistoricalObservationResults::Presenter.new
        service = Renalware::Pathology::ViewObservationResults.new(
          patient.observations, presenter, descriptions: descriptions)
        service.call
        view = ArrayStringifier.new(presenter.view_model).to_a

        expect(view).to match_array(rows)
      end

      def expect_pathology_current_observations(user:, patient:, rows:)
        patient = Renalware::Pathology.cast_patient(patient)
        curr_obs_set = patient.fetch_current_observation_set
        rows.reject!{ |row| row[1].blank? } # reject observations with no value
        codes = rows.map(&:first)[1..-1]

        expect(codes - curr_obs_set.values.keys).to eq([])
      end

      private

      def find_last_observation_request
        Renalware::Pathology::ObservationRequest.includes(observations: :description).last!
      end

      def find_observation(observations, description_code)
        observations.detect { |obs| obs.description.code == description_code }
      end
    end

    module Web
      include Domain

      def expect_pathology_recent_observations(user:, patient:, rows:)
        login_as user

        visit patient_pathology_recent_observations_path(patient)

        expect(page).to have_selector("table#observations tr:first-child td", count: 4)
      end

      def expect_pathology_historical_observations(user:, patient:, rows:)
        login_as user

        visit patient_pathology_historical_observations_path(patient)

        expect(page).to have_selector("table#observations tr", count: rows.size)
      end

      def expect_pathology_current_observations(user:, patient:, rows:)
        login_as user

        visit patient_pathology_current_observations_path(patient)

        puts "FIXME!! - need to reframe this test after changes to current obs"
        # number_of_observation_descriptions =
        #   Renalware::Pathology::RelevantObservationDescription.codes.size
        # expect(page).to have_selector("table.current-observations tbody tr",
        #                               count: number_of_observation_descriptions)
      end
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/pathology/*.rb")].each { |f| require f }
