require_dependency "renalware/pathology"
require "sql/index_case_stmt"

module Renalware
  module Pathology
    class ObservationDescriptionsByCodeQuery
      def initialize(relation: ObservationDescription, codes:)
        @relation = relation
        @codes = codes
      end

      def call
        stmt = SQL::IndexedCaseStmt.new(:code, @codes)
        records = @relation.where(code: @codes).order(stmt.generate)
        verify_all_records_found(records)
        records
      end

      private

      def verify_all_records_found(records)
        found_codes = records.map(&:code)

        unless found_codes == @codes
          raise ActiveRecord::RecordNotFound.new("Missing records for #{@codes - found_codes}")
        end
      end
    end
  end
end