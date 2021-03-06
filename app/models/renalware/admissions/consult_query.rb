# frozen_string_literal: true

require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class ConsultQuery
      attr_reader :query

      def initialize(query = nil)
        @query = query || {}
        @query[:ended_on_null] ||= true
        @query[:s] ||= "hospital_ward_name"
      end

      def call
        search.result
      end

      # Note we *MUST* join onto patients for PatientsRansackHelper.identity_match to work.
      # It might be better to refactor PatientsRansackHelper so we can include where required
      # eg below using .extending(PatientsRansackHelper) rather than relying on it being in
      # included in the model file.
      # note that adding .includes(:created_by) her creates an ambigous column
      # 'family_name' error
      def search
        @search ||= begin
          Consult
            .joins(:patient)
            .eager_load(patient: [current_modality: :description])
            .includes(
              :consult_site,
              :hospital_ward,
              patient: { current_modality: :description }
            )
            .order(created_at: :desc)
            .ransack(query)
        end
      end
    end
  end
end
