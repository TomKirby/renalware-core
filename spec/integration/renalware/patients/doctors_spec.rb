require "rails_helper"

RSpec.describe "Configuring Doctor", type: :request do
  let(:doctor) { create(:doctor) }

  describe "GET new" do
    it "responds with a form" do
      get new_patients_doctor_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    context "given valid attributes" do
      it "creates a new record" do
        address_attributes = attributes_for(:address)
        doctor_attributes = attributes_for(:doctor)
        doctor_address_attributes = doctor_attributes.merge(address_attributes: address_attributes)

        post patients_doctors_path, patients_doctor: doctor_address_attributes
        expect(response).to have_http_status(:redirect)
        expect(Renalware::Patients::Doctor.exists?(doctor_attributes)).to be_truthy
        expect(Renalware::Address.exists?(address_attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with form" do
        attributes = { given_name: "" }

        post patients_doctors_path, patients_doctor: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET index" do
    it "responds successfully" do
      get patients_doctors_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_patients_doctor_path(doctor)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = { given_name: "My Doctor" }
        patch patients_doctor_path(doctor), patients_doctor: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Patients::Doctor.exists?(attributes)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = { given_name: "" }
        patch patients_doctor_path(doctor), patients_doctor: attributes

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the doctor" do
      delete patients_doctor_path(doctor)

      expect(response).to have_http_status(:redirect)
      expect(Renalware::Patients::Doctor.exists?(id: doctor.id)).to be_falsey

      follow_redirect!

      expect(response).to have_http_status(:success)
    end
  end
end
