# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe UKRDC::TransmissionLog do
    it { is_expected.to validate_presence_of(:sent_at) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to belong_to(:patient).touch(false) }

    describe ".with_logging" do
      let(:uuid) { SecureRandom.uuid }

      context "when yielding to the supplied block" do
        context "when there is an exception" do
          it "catches the exception and logs the error message and set the status to 'error'" do
            patient = create(:patient)
            UKRDC::TransmissionLog.with_logging(patient, uuid) do
              raise ArgumentError
            end

            log = described_class.where(patient_id: patient.id).last

            expect(log.error).to match /ArgumentError/
            expect(log.status).to eq("error")
          end
        end

        context "when processing succeeds" do
          it "saves the log" do
            patient = create(:patient)
            described_class.with_logging(patient, uuid) do |log|
              log.payload = "XYZ"
              log.payload_hash = "123"
              log.sent!
            end

            log = described_class.where(patient_id: patient.id).last

            expect(log).to have_attributes(
              payload: "XYZ",
              payload_hash: "123",
              status: "sent"
            )
          end
        end

        context "when unsent because no changes in the xml are found since the last sent" do
          it "saves the log" do
            patient = create(:patient)
            described_class.with_logging(patient, uuid) do |log|
              log.payload = "XYZ"
              log.payload_hash = "123"
              log.unsent_no_change_since_last_send!
            end

            log = described_class.where(patient_id: patient.id).last

            expect(log).to have_attributes(
              payload: "XYZ",
              payload_hash: "123",
              status: "unsent_no_change_since_last_send"
            )
          end
        end
      end
    end
  end
end
