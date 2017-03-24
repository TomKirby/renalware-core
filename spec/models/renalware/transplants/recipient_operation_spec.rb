require "rails_helper"

module Renalware
  module Transplants
    describe RecipientOperation do
      it { is_expected.to validate_presence_of(:performed_on) }
      it { is_expected.to validate_presence_of(:theatre_case_start_time) }
      it { is_expected.to validate_presence_of(:donor_kidney_removed_from_ice_at) }
      it { is_expected.to validate_presence_of(:kidney_perfused_with_blood_at) }
      it { is_expected.to validate_presence_of(:operation_type) }
      it { is_expected.to validate_presence_of(:hospital_centre) }
      it { is_expected.to validate_presence_of(:cold_ischaemic_time_formatted) }
      it { is_expected.to validate_presence_of(:warm_ischaemic_time_formatted) }

      it { is_expected.to validate_timeliness_of(:donor_kidney_removed_from_ice_at) }
      it { is_expected.to validate_timeliness_of(:kidney_perfused_with_blood_at) }
      it { is_expected.to validate_timeliness_of(:theatre_case_start_time) }

      subject { build(:transplant_recipient_operation) }

      describe "#cold_ischaemic_time_formatted=" do
        it "stores duration in seconds" do
          subject.cold_ischaemic_time_formatted = "1:01"
          expect(subject.cold_ischaemic_time).to eq(3600 + 60)
        end
      end

      describe "#cold_ischaemic_time_formatted" do
        it "returns formatted duration in hh:mm" do
          subject.cold_ischaemic_time = 3600 + 60
          expect(subject.cold_ischaemic_time_formatted).to eq("1:01")
        end
      end

      describe "#warm_ischaemic_time_formatted=" do
        it "stores duration in seconds" do
          subject.warm_ischaemic_time_formatted = "1:01"
          expect(subject.warm_ischaemic_time).to eq(3600 + 60)
        end
      end

      describe "#warm_ischaemic_time_formatted" do
        it "returns formatted duration in hh:mm" do
          subject.warm_ischaemic_time = 3600 + 60
          expect(subject.warm_ischaemic_time_formatted).to eq("1:01")
        end
      end
    end
  end
end
