# frozen_string_literal: true

require "rails_helper"

module Renalware
  module UKRDC
    describe PatientPresenter do
      def smoker(status)
        patient = Patient.new(sent_to_ukrdc_at: 1.year.ago)
        patient.document.history.smoking = status
        UKRDC::PatientPresenter.new(patient).smoking_history
      end

      describe "#smoking_history" do
        it "converts RW enums to RRSMOKING codes" do
          expect(smoker(:no)).to eq("NO")
          expect(smoker(:yes)).to eq("YES")
          expect(smoker(:ex)).to eq("EX")
        end
      end
    end
  end
end
