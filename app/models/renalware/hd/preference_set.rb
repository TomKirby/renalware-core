require_dependency "renalware/hd"

module Renalware
  module HD
    class PreferenceSet < ApplicationRecord
      include PatientScope
      include Accountable
      include HasSchedule

      belongs_to :patient
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"

      has_paper_trail class_name: "Renalware::HD::Version"

      validates :patient, presence: true
      validates :entered_on, timeliness: { type: :date, allow_blank: true }

      delegate :hospital_centre, to: :hospital_unit, allow_nil: true

      def preferred_schedule
        other_schedule_required? ? other_schedule : schedule.try(:text)
      end
    end
  end
end
