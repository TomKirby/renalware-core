# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Clinical Studies management", type: :request do
  let(:user) { @current_user }

  def create_study
    create(
      :research_study,
      code: "Study1",
      description: "Study 1",
      leader: "Jack Jones",
      application_url: "http://example.com"
    )
  end

  describe "GET index" do
    it "renders a list of clinical studies" do
      study = create_study

      get research_studies_path

      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(response.body).to match("Clinical Studies")
      expect(response.body).to match("Add")
      expect(response.body).to match(study.code)
      expect(response.body).to match(study.description)
      expect(response.body).to match(study.leader)
    end
  end

  describe "GET new" do
    it "renders a form" do
      get new_research_study_path

      expect(response).to be_successful
      expect(response).to render_template(:new)
      expect(response.body).to match("Clinical Studies")
      expect(response.body).to match("New")
    end
  end

  describe "POST create" do
    context "with valid inputs" do
      it "creates a new study and redirects to index" do
        study_params = {
          code: "ABC",
          description: "A B C",
          leader: "Mr X",
          notes: "Notes",
          started_on: 1.year.ago,
          terminated_on: 1.day.ago,
          application_url: "http://example.com"
        }

        post research_studies_path, params: { research_study: study_params }

        follow_redirect!
        expect(response).to be_successful
        expect(response).to render_template(:index)

        study = Renalware::Research::Study.first
        expect(study.code).to eq(study_params[:code])
        expect(study.description).to eq(study_params[:description])
        expect(study.notes).to eq(study_params[:notes])
        expect(study.leader).to eq(study_params[:leader])
        expect(study.started_on.to_date).to eq(study_params[:started_on].to_date)
        expect(study.terminated_on.to_date).to eq(study_params[:terminated_on].to_date)
        expect(study.application_url).to eq("http://example.com")
      end
    end

    context "with invalid inputs" do
      it "re-renders the form with validation errors" do
        params = {
          research_study: {
            code: nil
          }
        }
        post research_studies_path, params: params

        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET edit" do
    it "renders the form" do
      study = create_study

      get edit_research_study_path(study)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
      expect(response.body).to match("Clinical Studies")
      expect(response.body).to match("Edit")
    end
  end

  describe "PATCH update" do
    context "with valid inputs" do
      it "updates an existing study and redirects to index" do
        study = create_study

        params = { research_study: { code: "Study1a" } }

        patch research_study_path(study), params: params

        follow_redirect!
        expect(response).to be_successful
        expect(response).to render_template(:index)

        study.reload

        expect(study.code).to eq("Study1a")
      end
    end

    context "with invalid inputs" do
      it "re-renders the form with validation errors" do
        params = {
          research_study: {
            code: nil
          }
        }
        post research_studies_path, params: params

        expect(response).to be_successful
        expect(response.body).to match(/error/)
      end
    end
  end

  describe "DELETE destroy" do
    it "soft-deletes the study" do
      study = create_study
      create(:research_study_participant, study: study)

      expect {
        delete research_study_path(study)
      }.to change{ Renalware::Research::Study.count }.by(-1)
       .and change{ Renalware::Research::StudyParticipant.count }.by(-1)
       .and change{ Renalware::Research::Study.deleted.count }.by(1)
       .and change{ Renalware::Research::StudyParticipant.deleted.count }.by(1)

      follow_redirect!
      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(study.reload).to be_deleted
    end
  end
end
