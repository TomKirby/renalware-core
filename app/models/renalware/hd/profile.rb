require_dependency "renalware/hd"
require "document/base"

module Renalware
  module HD
    class Profile < ApplicationRecord
      include Document::Base
      include PatientScope
      include HasSchedule
      include Accountable
      include Supersedeable

      belongs_to :patient, touch: true
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      belongs_to :prescriber, class_name: "User", foreign_key: "prescriber_id"
      belongs_to :named_nurse, class_name: "User", foreign_key: "named_nurse_id"
      belongs_to :transport_decider, class_name: "User", foreign_key: "transport_decider_id"

      has_document class_name: "Renalware::HD::ProfileDocument"
      has_paper_trail class_name: "Renalware::HD::Version"

      validates :patient, presence: true
      validates :prescriber, presence: true

      delegate :hospital_centre, to: :hospital_unit, allow_nil: true

      scope :ordered, -> { order(deactivated_at: :desc) }

      def self.policy_class
        BasePolicy
      end
    end
  end
end
