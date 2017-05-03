require "rails_helper"

RSpec.describe "New Visit from existing Appointment", type: :feature do
  describe "GET index" do
    context "with no appointment id" do
      it "does not pre-populate the form" do
        login_as_clinician
        patient = Renalware::Clinics.cast_patient(create(:patient))

        visit new_patient_clinic_visit_path(patient)

        expect(find_field("Date").value).to eq ""
        expect(find_field("Time").value).to eq ""
        expect(find_field("Clinic").value).to eq ""
      end
    end

    context "with an appointment id passed" do
      it "pre-populates the form with the details copied from the appointment" do
        login_as_clinician
        clinic = create(:clinic)
        patient = Renalware::Clinics.cast_patient(create(:patient))
        appointment = create(:appointment,
                             patient: patient,
                             clinic: clinic,
                             starts_at: Time.zone.now)

        visit new_patient_clinic_visit_path(patient, appointment_id: appointment.id)

        expect(find_field("Date").value).to eq(I18n.l(appointment.starts_at.to_date))
        expect(find_field("Time").value).to eq(appointment.starts_at.strftime("%H:%M"))
        expect(find_field("Clinic").value).to eq(appointment.clinic.id.to_s)

        within ".document" do
          click_on "Save"
        end

        expect(patient.clinic_visits.length).to eq(1)
        expect(appointment.reload.becomes_visit_id).to eq(patient.clinic_visits.first.id)
      end
    end
  end
end