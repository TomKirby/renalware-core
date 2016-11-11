module Renalware
  module HD
    class UpdateRollingPatientStatistics < ActiveJob::Base

      def initialize(patient:)
        @patient = patient
      end

      def call
        return unless recent_sessions.any?
        stats = rolling_stats_for_this_patient
        stats.hospital_unit = most_recently_used_hospital_unit
        stats.assign_attributes(auditable_sessions.to_h)
        stats.save!
      end

      private

      attr_reader :patient

      def recent_sessions
        @recent_sessions ||= Sessions::LatestPatientSessionsQuery.new(patient: patient).call
      end

      def auditable_sessions
        @auditable_sessions ||= Sessions:: AuditableSessionCollection.new(recent_sessions)
      end

      def rolling_stats_for_this_patient
        @patient_rolling_stats ||= begin
          PatientStatistics.where(patient: patient,
                                  rolling: true,
                                  year: nil,
                                  month: nil).first_or_initialize
        end
      end

      def most_recently_used_hospital_unit
        recent_sessions.last.hospital_unit
      end
    end
  end
end