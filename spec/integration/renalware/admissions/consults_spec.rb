# rubocop:disable Metrics/ModuleLength
require "rails_helper"
module Renalware
  RSpec.describe "Admission Consult management", type: :request do
    let(:user) { @current_user }
    let(:time) { Time.zone.now }
    let(:consult_site) { create(:admissions_consult_site, name: "Site1") }
    let(:hospital_unit) { create(:hospital_unit, unit_code: "HospUnit1") }
    let(:hospital_ward) { create(:hospital_ward, name: "Ward1", hospital_unit: hospital_unit) }

    def convert_hash_dates_to_string_using_locale(hash)
      hash.each { |key, val| hash[key] = I18n.l(val) if val.is_a?(Date) }
    end

    def create_consult
      create(:admissions_consult,
             by: user,
             patient: create(:patient, by: user),
             started_on: Time.zone.today,
             consult_site: consult_site,
             hospital_ward: hospital_ward,
             consult_type: "TBC",
             description: "Lorem ipsum dolor")
    end

    describe "GET index" do
      it "lists consults" do
        consult = create_consult

        get admissions_consults_path

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Admission Consults")
        expect(response.body).to include("Site1")
        expect(response.body).to include(consult.patient.to_s)
      end
    end

    describe "GET new" do
      it "renders a modal to allow a patient to be selected" do
        get new_admissions_consult_path

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new, format: :html)
      end
    end

    describe "POST JS create" do
      context "with valid inputs" do
        it "creates the consult" do
          patient = create(:patient, by: user)
          create(:hospital_ward, name: "Ward1", hospital_unit: hospital_unit)
          date = I18n.l(Time.zone.today)

          params = {
            patient_id: patient.id,
            consult_site_id: consult_site.id,
            hospital_ward_id: hospital_unit.wards.first.id,
            other_site_or_ward: "X",
            started_on: date,
            decided_on: date,
            transferred_on: date,
            consult_type: "TBC",
            transfer_priority: Renalware::Admissions::Consult.transfer_priority.values.first,
            aki_risk: Renalware::Admissions::Consult.aki_risk.values.first,
            seen_by_id: user.id,
            contact_number: "x123",
            requires_aki_nurse: true,
            description: "Lorem ipsum dolor sit amet"
          }

          post admissions_consults_path, params: { admissions_consult: params }

          follow_redirect!
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)

          consults = Renalware::Admissions::Consult.all
          expect(consults.length).to eq(1)
          consult = consults.first

          # Do a direct diff on supplied params and the saved object's attributes, excluding
          # attributes that we don't care about.
          attribs = consult.attributes.symbolize_keys.except(
            :id, :updated_at, :created_at, :created_by_id, :updated_by_id, :deleted_at, :ended_on
          )
          convert_hash_dates_to_string_using_locale(attribs)
          expect(HashDiff.diff(params, attribs)).to eq([])
        end
      end

      context "with invalid inputs" do
        it "re-renders the modal form with validation errors" do
          params = { patient_id: nil }

          post admissions_consults_path, params: { admissions_consult: params }

          expect(response).to have_http_status(:success)
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET html edit" do
      it "renders the form" do
        get edit_admissions_consult_path(create_consult)

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
    end

    describe "PATCH html update" do
      context "with valid inputs" do
        it "updates the consult" do
          consult = create_consult
          consult_site2 = create(:admissions_consult_site, name: "Site2")

          params = { consult_site_id: consult_site2.id }

          patch(admissions_consult_path(consult),
                params: { admissions_consult: params })

          follow_redirect!
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)
          expect(consult.reload.consult_site_id).to eq(consult_site2.id)
        end
      end

      context "with invalid inputs" do
        it "re-renders the modal form with validation errors" do
          consult = create_consult
          # other_site_or_ward must be provided if consult_site_id & hospital_ward_id are nil
          params = { consult_site_id: nil, hospital_ward_id: nil, other_site_or_ward: nil }

          patch(admissions_consult_path(consult), params: { admissions_consult: params })

          expect(response).to have_http_status(:success)
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "DELETE html destroy" do
      it "soft deletes the consult and sets the ended_on date to today" do
        consult = create_consult

        expect{
          delete admissions_consult_path(consult)
        }
        .to change{ Admissions::Consult.count }.by(-1)
        .and change{ Admissions::Consult.deleted.count }.by(1)
      end
    end
  end
end