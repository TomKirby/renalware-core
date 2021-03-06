# frozen_string_literal: true

require "rails_helper"
require_dependency "renalware/renal"

RSpec.describe "Renal Profile (ESRF/Comorbidities)", type: :feature, js: true do
  describe "GET #show" do
    it "updating the renal profile" do
      user = login_as_clinical

      esrf_date = "24-Mar-2017"
      patient = Renalware::Renal.cast_patient(create(:patient, by: user))
      profile = patient.build_profile
      profile.esrf_on = esrf_date
      profile.save!

      visit patient_path(patient)
      within ".side-nav" do
        click_on "ESRF/Comorbidities"
      end

      # Renal profile #show
      expect(page).to have_current_path(patient_renal_profile_path(patient))
      expect(page).to have_content(esrf_date)

      within ".page-actions" do
        click_on "Edit"
      end

      # Renal profile #edit
      expect(page).to have_current_path(edit_patient_renal_profile_path(patient))

      updated_esrf_date = "25-Mar-2016"
      fill_in "ESRF Date", with: updated_esrf_date
      within page.first(".form-actions") do
        click_on "Save"
      end

      # Renal profile #show
      expect(page).to have_current_path(patient_renal_profile_path(patient))
      expect(page).to have_content(updated_esrf_date)
    end

    it "pulling in the patient's current address" do
      user = login_as_clinical
      patient = Renalware::Renal.cast_patient(create(:patient, by: user))

      visit edit_patient_renal_profile_path(patient)

      within "#address_at_diagnosis" do
        fill_in "Line 1", with: "Somewhere"
        click_on "Use current address"
        expect(find_field("Line 1").value).to eq("123 Legoland")
      end
    end
  end
end
