# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Displaying the patient worryboard", type: :request do
  let(:user) { @current_user }

  describe "GET index" do
    it "views patients having a worry (who are on the worryboard)" do
      patient = create(:patient, family_name: "Renaldo", by: user)
      worry = Renalware::Patients::Worry.new(patient: patient, by: user)
      worry.save!

      get worryboard_path

      expect(response).to have_http_status(:success)
      expect(response.body).to match(/#{patient.family_name}/i)
    end
  end
end
