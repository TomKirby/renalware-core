# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Patient Transplant MDM", type: :request do
  let(:patient) { create(:transplant_patient, family_name: "Rabbit", local_patient_id: "KCH12345") }

  describe "GET show" do
    it "responds successfully" do
      create(:pathology_observation_description, code: "HGB")
      create(:pathology_observation_description, code: "CMVDNA")

      get patient_transplants_mdm_path(patient)

      expect(response).to have_http_status(:success)
    end
  end
end
