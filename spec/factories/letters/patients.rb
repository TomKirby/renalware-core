# frozen_string_literal: true

FactoryBot.define do
  factory :letter_patient, class: "Renalware::Letters::Patient", parent: :patient
end
