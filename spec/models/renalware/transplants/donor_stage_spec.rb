require "rails_helper"

module Renalware
  module Transplants
    describe DonorStage do
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to belong_to(:stage_position) }
      it { is_expected.to belong_to(:stage_status) }
      it { is_expected.to validate_presence_of(:stage_position) }
      it { is_expected.to respond_to(:created_by) }
      it { is_expected.to respond_to(:updated_by) }
      it { is_expected.to respond_to(:started_on) }
      it { is_expected.to respond_to(:terminated_on) }
      it { is_expected.to validate_presence_of(:stage_status) }
      it { is_expected.to validate_presence_of(:started_on) }
      it { is_expected.not_to validate_presence_of(:terminated_on) }

      describe "class methods" do
        subject { DonorStage }

        it { is_expected.to respond_to(:for_patient) }
      end

      describe "scopes" do
        describe "#current" do
          it "returns the one and only current status ie the only one (for this patient) "\
             "without a termination date" do
            patient = Transplants.cast_patient(create(:patient, family_name: "Ng"))
            terminated_status = create(:donor_stage,
                                       patient: patient,
                                       started_on: 1.week.ago,
                                       terminated_on: 1.day.ago)
            current_status = create(:donor_stage,
                                    patient: patient,
                                    started_on: terminated_status.terminated_on,
                                    terminated_on: nil)

            current = DonorStage.for_patient(patient).current
            expect(current.length).to eq(1)
            expect(current.first.id).to eq(current_status.id)
          end
        end
      end
    end
  end
end
