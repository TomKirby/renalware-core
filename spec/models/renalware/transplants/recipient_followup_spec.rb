# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Transplants
    describe RecipientFollowup do
      require "rails_helper"

      it { is_expected.to belong_to(:operation).touch(true) }
      it { is_expected.to validate_timeliness_of(:stent_removed_on) }
      it { is_expected.to validate_timeliness_of(:transplant_failed_on) }

      describe "#valid?" do
        subject do
          RecipientFollowup.new(
            attributes_for(:transplant_recipient_followup).merge(attributes)
          )
        end

        let(:attributes) { {} }

        it { is_expected.to be_valid }

        context "when transplant failed" do
          let(:attributes) { { transplant_failed: true } }

          it { is_expected.to validate_presence_of(:transplant_failed_on) }
          it { is_expected.to validate_presence_of(:transplant_failure_cause_description_id) }
        end

        context "with a transplant failure cause" do
          let(:description) do
            Renalware::Transplants::FailureCauseDescription.create(
              code: "41",
              name: "Other"
            )
          end
          let(:attributes) { { transplant_failure_cause_description_id: description.id } }

          it { is_expected.to validate_presence_of(:transplant_failure_cause_other) }
        end
      end
    end
  end
end
