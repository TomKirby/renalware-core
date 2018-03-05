# frozen_string_literal: true

require "rails_helper"

module Renalware::Patients
  RSpec.describe MessageParamParser do
    describe "#parse" do
      let(:message_payload) {
        double(
          :message_payload,
          patient_identification: double(
            internal_id: "::internal id::",
            external_id: "::external id::",
            family_name: "::family name::",
            given_name: "::given name::",
            sex: "F",
            dob: "19880924"
          )
        )
      }

      it "transfers attributes from the message payload to the params" do
        params = subject.parse(message_payload)

        expect(params).to eq(
          {
            patient: {
              nhs_number: "::external id::",
              local_patient_id: "::internal id::",
              family_name: "::family name::",
              given_name: "::given name::",
              sex: "F",
              born_on: "1988-09-24"
            }
          }
        )
      end
    end
  end
end
