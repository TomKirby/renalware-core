require "rails_helper"

module Renalware
  describe Modalities::Modality, type: :model do
    it { should validate_presence_of :patient }
    it { should validate_presence_of :started_on }
    it { should validate_presence_of :description }

    it { is_expected.to validate_timeliness_of(:started_on) }

    describe "validate start date based on previous modalities" do
      let!(:another_patients_modality) { create(:modality, started_on: Date.parse("2015-06-02")) }

      context "given there is no previous modality" do
        subject do
          build(:modality, started_on: Date.parse("2015-05-01"))
        end

        it "has a valid start date" do
          subject.valid?
          expect(subject.errors[:started_on]).to be_empty
        end
      end

      context "given there is a previous modality" do
        let!(:patients_modality) { create(:modality, started_on: Date.parse("2015-04-01")) }

        context "given start date is later than previous start date" do
          subject do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-05-01")
            )
          end

          it "has a valid start date" do
            subject.valid?
            expect(subject.errors[:started_on]).to be_empty
          end
        end

        context "given start date is the same as the previous start date" do
          subject do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-04-01")
            )
          end

          it "has a valid start date" do
            subject.valid?
            expect(subject.errors[:started_on]).to be_empty
          end
        end

        context "given start date is not later than previous start date" do
          subject do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-03-21")
            )
          end

          it "has an invalid start date" do
            subject.valid?
            expect(subject.errors[:started_on]).to include(/previous modality/)
          end
        end
      end
    end

    describe "#transfer!" do
      subject { create(:modality) }
      let(:started_on) { Date.parse("2015-04-21") }

      before do
        modality_description = FactoryGirl.create(:modality_description, :capd_standard)
        @actual = subject.transfer!(description: modality_description,
                                    notes: "Some notes",
                                    started_on: started_on,
                                    by: create(:user))
      end

      it "updates the end date" do
        expect(subject.ended_on).to eq(started_on)
      end

      it "terminates the modality" do
        expect(subject).to be_terminated
      end

      it "creates a valid modality" do
        expect(@actual).to be_valid
        expect(@actual.notes).to eq("Some notes")
        expect(@actual.started_on).to eq(started_on)
      end
    end

  end
end
