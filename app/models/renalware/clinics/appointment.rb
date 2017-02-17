require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class Appointment < ApplicationRecord

      belongs_to :patient
      belongs_to :clinic
      belongs_to :user

      validates_presence_of :starts_at
      validates_presence_of :patient
      validates_presence_of :clinic
      validates_presence_of :user

      validates :starts_at, timeliness: { type: :datetime }

      def starts_on
        starts_at.to_date
      end

      def start_time
        starts_at.strftime("%H:%M")
      end
    end
  end
end
