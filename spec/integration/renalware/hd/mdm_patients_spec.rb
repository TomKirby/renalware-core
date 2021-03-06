# frozen_string_literal: true

require "rails_helper"

RSpec.describe "HD MDM Patients", type: :feature do
  include PatientsSpecHelper
  let(:user) { create(:user) }

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create_hd_patient(unit:, family_name:, schedule_definition:, by: user)
    create(:hd_patient, family_name: family_name, by: user).tap do |patient|
      patient.hd_profile = create(:hd_profile,
                                   patient: patient,
                                   hospital_unit: unit,
                                   schedule_definition: schedule_definition,
                                   by: user)
      set_modality(patient: patient,
                   modality_description: create(:hd_modality_description),
                   by: by)

      create(:prescription, patient: patient, by: user)
      pres = create(:prescription, patient: patient, prescribed_on: 1.day.ago, by: user)
      create(:prescription_termination,
             prescription: pres,
             terminated_on: Time.zone.now,
             by: user)
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  describe "GET index" do
    it "responds successfully" do
      patient = create(:hd_patient,
                       family_name: "Rabbit",
                       local_patient_id: "KCH12345",
                       by: user)

      set_modality(patient: patient,
                   modality_description: create(:hd_modality_description),
                   by: user)

      login_as_clinical
      visit hd_mdm_patients_path

      expect(page).to have_content(patient.family_name.upcase)
    end

    it "filters by hospital unit and HD schedule" do
      hospital = create(:hospital_centre)
      unit1 = create(:hd_hospital_unit, name: "Unit1", hospital_centre: hospital)
      unit2 = create(:hd_hospital_unit, name: "Unit2", hospital_centre: hospital)
      mon_wed_fri_am = create(:schedule_definition, :mon_wed_fri_am)
      mon_wed_fri_pm = create(:schedule_definition, :mon_wed_fri_pm)

      patient1 = create_hd_patient(
        unit: unit1,
        family_name: "XXXX",
        schedule_definition: mon_wed_fri_am
      )
      patient2 = create_hd_patient(
        unit: unit2,
        family_name: "YYYY",
        schedule_definition: mon_wed_fri_pm
      )

      login_as_clinical
      visit hd_mdm_patients_path

      # See all
      expect(page).to have_content(patient1.family_name)
      expect(page).to have_content(patient2.family_name)

      # Show only those patients dialysing in unit1
      select unit1.name, from: "Hosp. Unit"
      click_on I18n.t("helpers.submit.filter")

      expect(page).to have_content(patient1.family_name)
      expect(page).to have_no_content(patient2.family_name)

      # Reset filters to see all
      click_on I18n.t("helpers.reset")
      expect(page).to have_content(patient1.family_name)
      expect(page).to have_content(patient2.family_name)

      # Show only those patients scheduled at this time
      select "Mon Wed Fri PM", from: "Schedule"
      click_on I18n.t("helpers.submit.filter")

      expect(page).to have_content(patient2.family_name)
      expect(page).to have_no_content(patient1.family_name)
    end
  end
end
