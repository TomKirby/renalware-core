# frozen_string_literal: true

require "rails_helper"

RSpec.describe "HD Summary (Dashboard)", type: :request do
  let(:patient) { create(:hd_patient) }
  let(:user) { create(:user) }

  describe "GET" do
    it "renders the HD Summary" do
      get patient_hd_dashboard_path(patient)

      expect(response).to have_http_status(:success)
    end
  end
end
