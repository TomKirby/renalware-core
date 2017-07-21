require "rails_helper"

module Renalware
  module Accesses
    RSpec.describe AssessmentFactory, type: :model do
      subject { AssessmentFactory.new(patient: patient) }

      let(:user) { create(:user, :admin) }
      let(:patient) { Accesses.cast_patient(create(:patient)) }

      describe "#build" do
        it "applies default to the assessment" do
          travel_to Time.zone.parse("2004-11-24 01:04:44")

          assessment = subject.build

          expect(assessment.performed_on.to_s).to eq("2004-11-24")
        end

        context "with a current access profile" do
          let!(:profile) { create(:access_profile, :current, patient: patient) }

          it "applies the access details from the current access" do
            assessment = subject.build

            expect(assessment.type).to eq(profile.type)
            expect(assessment.side).to eq(profile.side)
          end
        end
      end
    end
  end
end
