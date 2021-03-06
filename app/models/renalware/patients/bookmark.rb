# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class Bookmark < ApplicationRecord
      acts_as_paranoid

      belongs_to :user, class_name: "Renalware::Patients::User", foreign_key: :user_id
      # No touch required on patient
      belongs_to :patient, class_name: "Renalware::Patient", foreign_key: :patient_id

      validates :patient, presence: true
      validates :user, presence: true
      validates :user_id, uniqueness: { scope: [:patient_id, :deleted_at] }

      scope :ordered, -> { order(urgent: :desc, updated_at: :asc) }
    end
  end
end
