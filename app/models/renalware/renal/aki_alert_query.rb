# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Renal
    class AKIAlertQuery
      DEFAULT_SORT = "aki_date desc"
      attr_reader :query

      def initialize(query = nil)
        @query = query || {}
        @query[:s] = DEFAULT_SORT if @query[:s].blank?
      end

      def self.call(query)
        new(query).call
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          AKIAlert
            .joins(:patient) # required for PatientsRansackHelper - see Admission
            .includes(:patient, :updated_by, :action, hospital_ward: :hospital_unit)
            .eager_load(patient: [current_modality: :description])
            .public_send(query[:named_filter].to_s)
            .ransack(query)
        end
      end
    end
  end
end
