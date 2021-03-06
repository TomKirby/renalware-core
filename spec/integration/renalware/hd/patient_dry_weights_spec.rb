# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Patient's Dry Weights", type: :request do
  let(:patient) { create(:hd_patient) }

  describe "GET index" do
    before do
      create(:dry_weight, patient: Renalware::Clinical.cast_patient(patient))
    end

    it "responds with a list" do
      get patient_clinical_dry_weights_path(patient_id: patient)

      expect(response).to have_http_status(:success)
    end
  end
end
