# frozen_string_literal: true

require_dependency "renalware/pathology"
require "sql/index_case_stmt"

module Renalware
  module Pathology
    class OrderedPatientQuery
      def initialize(patient_ids)
        @patient_ids = patient_ids
      end

      def call
        Pathology::Patient
          .where(id: @patient_ids)
          .order(ids_index)
      end

      private

      def ids_index
        ::SQL::IndexedCaseStmt.new(:id, @patient_ids).generate
      end
    end
  end
end
