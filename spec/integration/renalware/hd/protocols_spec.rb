require "rails_helper"

RSpec.describe "Patient's Protocol PDF", type: :request do
  let(:patient) { create(:hd_patient, family_name: "Rabbit", local_patient_id: "KCH12345") }

  describe "GET show" do
    it "responds with an inlined PDF by default" do
      get patient_hd_protocol_path(patient_id: patient.id)

      expect(response).to have_http_status(:success)
      expect(response).to be_success
      expect(response["Content-Type"]).to eq("application/pdf")
      expect(response["Content-Disposition"]).to include("inline")
    end

    it "can responds with a PDF download" do
      get patient_hd_protocol_path(patient_id: patient.id, disposition: :attachment)

      expect(response).to be_success
      expect(response["Content-Type"]).to eq("application/pdf")
      filename = "RABBIT-KCH12345-PROTOCOL.pdf"
      expect(response["Content-Disposition"]).to include("attachment")
      expect(response["Content-Disposition"]).to include(filename)
    end
  end
end