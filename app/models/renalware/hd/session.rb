require_dependency "renalware/hd"
require "document/base"

module Renalware
  module HD
    class Session < ActiveRecord::Base
      include Document::Base
      include PatientScope
      include Accountable

      belongs_to :patient
      belongs_to :modality_description, class_name: "Modalities::Description"
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      belongs_to :signed_on_by, class_name: "User", foreign_key: "signed_on_by_id"
      belongs_to :signed_off_by, class_name: "User", foreign_key: "signed_off_by_id"

      has_document class_name: "Renalware::HD::SessionDocument"
      has_paper_trail class_name: "Renalware::HD::Version"

      before_create :assign_modality

      scope :ordered, -> () { order(performed_on: :desc) }

      validates :patient, presence: true
      validates :hospital_unit, presence: true
      validates :signed_on_by, presence: true

      validates :performed_on, presence: true
      validates :performed_on, timeliness: { type: :date }

      validates :start_time, presence: true
      validates :start_time, timeliness: { type: :time }

      validates :end_time, timeliness: { type: :time, allow_blank: true, after: :start_time }

      delegate :hospital_centre, to: :hospital_unit, allow_nil: true

      def self.new_for_patient(patient, current_user:)
        session = new(
          performed_on: Time.zone.today,
          signed_on_by: current_user,
          start_time: Time.zone.now.change(min: (Time.zone.now.min/5)*5)
        )
        Profile.for_patient(patient).first.tap do |profile|
          session.hospital_unit = profile.hospital_unit
          session.document.info.hd_type = profile.document.dialysis.hd_type
        end

        session
      end

      def signed_off?
        signed_off_by.present? && end_time.present?
      end

      def duration
        end_time.present? ? (end_time - start_time).to_i/60 : nil
      end

      private

      def assign_modality
        self.modality_description = patient.modality_description
      end
    end
  end
end
