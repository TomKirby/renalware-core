# frozen_string_literal: true

require "rails_helper"

module Renalware::Problems
  RSpec.describe ProblemsController, type: :controller do
    routes { Renalware::Engine.routes }
    let(:patient) { create(:patient, by: @current_user) }
    let(:problem) { create(:problem, patient: patient, by: @current_user) }

    describe "GET index" do
      it "responds with success" do
        get :index, params: { patient_id: patient }
        expect(response).to have_http_status(:success)
      end
    end

    describe "PUT update" do
      context "with valid attributes" do
        it "redirects to the problem index" do
          put :update,
              params: {
                patient_id: patient,
                id: problem,
                problems_problem: { description: "testing" }
              }

          expect(response).to redirect_to(patient_problem_path(patient, problem))
        end
      end

      context "with invalid attributes" do
        it "redirects to the problem index as invalid problems are rejected" do
          put :update,
              params: {
                patient_id: patient,
                id: problem,
                problems_problem: { description: "" }
              }

          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
