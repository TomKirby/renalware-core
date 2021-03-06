# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Viewing the dashboard", type: :feature do
  let(:patient) { create(:virology_patient) }

  it "is accessible from the patient LH menu" do
    login_as_clinical
    visit patient_path(patient)

    within ".side-nav" do
      click_on "Virology"
    end

    expect(page).to have_current_path(patient_virology_dashboard_path(patient))
  end

  it "displays vaccinations" do
    user = login_as_clinical
    date = "2017-12-12 00:00:01"
    create(
      :vaccination,
      patient: patient,
      date_time: Time.zone.parse(date),
      by: user,
      document: {
        type: :hbv1
      }
    )

    visit patient_virology_dashboard_path(patient)

    within ".patient-content" do
      expect(page).to have_content("Virology")
      expect(page).to have_content("Vaccinations")

      within "article.vaccinations" do
        expect(page).to have_content("Desc")
        expect(page).to have_content("12-Dec-2017")
        within "header" do
          expect(page).to have_content("Add")
        end
      end
    end
  end

  it "displays hiv, hepatitis c, hepatitis b" do
    user = login_as_clinical
    patient.build_profile
    patient.profile.document.hiv.status = :yes
    patient.profile.document.hiv.confirmed_on_year = 2001
    patient.save_by!(user)

    visit patient_virology_dashboard_path(patient)

    within ".patient-content" do
      expect(page).to have_content("HIV")
      expect(page).to have_content("Yes (2001)")
    end
  end
end
