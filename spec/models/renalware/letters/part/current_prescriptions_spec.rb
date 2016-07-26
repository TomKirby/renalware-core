require "rails_helper"

module Renalware::Letters
  describe Part::CurrentPrescriptions do
    let(:prescription) { build(:prescription) }
    let(:patient) { double(:patient, prescriptions: [prescription]) }
    subject(:current_prescriptions_part) { Part::CurrentPrescriptions.new(patient) }

    it "delegates to the patient's presented current prescriptions"do
      expect(current_prescriptions_part.first).to be_a(::Renalware::Medications::Prescription)
    end
  end
end