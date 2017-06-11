require "rails_helper"

RSpec.describe "Configuring Drugs", type: :request do
  let(:drug) { create(:drug) }

  describe "GET new" do
    it "responds with a form" do
      get new_drugs_drug_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    context "given valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:drug)

        post drugs_drugs_path, params: { drugs_drug: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Drugs::Drug.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        attributes = { name: "" }

        post drugs_drugs_path, params: { drugs_drug: attributes }

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET index" do
    it "responds successfully" do
      get drugs_drugs_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET index as JSON" do
    it "responds with json" do
      create(:drug, name: "::drug name::")

      get drugs_drugs_path, params: { format: :json }

      expect(response).to have_http_status(:success)

      parsed_json = JSON.parse(response.body)

      expect(parsed_json.size).to eq(1)
      expect(parsed_json.first["name"]).to eq("::drug name::")
    end
  end

  describe "GET index with search" do
    it "responds with a filtered list of records matching the query" do
      create(:drug, name: "::target drug name::")
      create(:drug, name: "::another drug name::")

      get drugs_drugs_path, params: { q: { name_or_drug_types_name_start: "::target" } }

      expect(response).to have_http_status(:success)
      expect(response.body).to match("::target drug name::")
      expect(response.body).not_to match("::another drug name::")
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_drugs_drug_path(drug)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = { name: "::drug_name::" }

        patch drugs_drug_path(drug), params: { drugs_drug: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Drugs::Drug.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = { name: "" }

        patch drugs_drug_path(drug), params: { drugs_drug: attributes }

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the drug" do
      delete drugs_drug_path(drug)

      expect(response).to have_http_status(:redirect)
      expect(Renalware::Drugs::Drug.exists?(id: drug.id)).to be_falsey

      follow_redirect!

      expect(response).to have_http_status(:success)
    end
  end

end
