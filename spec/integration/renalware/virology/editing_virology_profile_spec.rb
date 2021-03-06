# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editing the virology profile", type: :feature do
  let(:patient) { create(:virology_patient) }

  it "will build a new profile for the form if the patient had none" do
    login_as_clinical
    visit patient_virology_dashboard_path(patient)

    within ".page-actions" do
      click_on "Edit Profile"
    end

    expect(page).to have_current_path(edit_patient_virology_profile_path(patient))

    within(".hiv") do
      choose("Yes")
      select("2012", from: "Diagnosed")
    end

    within(".hepatitis_b") do
      choose("No")
      select("2011", from: "Diagnosed")
    end

    within(".hepatitis_c") do
      choose("Unknown")
    end

    within ".patient-content" do
      click_on "Save"
    end

    expect(page).to have_current_path(patient_virology_dashboard_path(patient))

    document = patient.reload.profile.document
    expect(document.hiv.status.to_s).to eq("yes")
    expect(document.hiv.confirmed_on_year).to eq(2012)
    expect(document.hepatitis_b.status.to_s).to eq("no")
    expect(document.hepatitis_b.confirmed_on_year).to eq(2011)
    expect(document.hepatitis_c.status.to_s).to eq("unknown")
    expect(document.hepatitis_c.confirmed_on_year).to be_blank
  end
end
