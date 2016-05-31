require "rails_helper"

RSpec.describe "Configuring Event Types", type: :request do
  let(:event_type) { create(:events_type) }

  describe "GET new" do
    it "responds with a form" do
      get new_events_type_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    context "given valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:events_type)
        post events_types_path, events_type: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Events::Type.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        attributes = {name: ""}
        post events_types_path, events_type: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_events_type_path(event_type)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = {name: "My Edited Event"}
        patch events_type_path(event_type), events_type: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Events::Type.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = {name: ""}
        patch events_type_path(event_type), events_type: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the event type" do
      delete events_type_path(event_type)
      expect(response).to have_http_status(:redirect)

      expect(Renalware::Events::Type.exists?(id: event_type.id)).to be_falsey

      follow_redirect!
      expect(response).to have_http_status(:success)
    end
  end
end