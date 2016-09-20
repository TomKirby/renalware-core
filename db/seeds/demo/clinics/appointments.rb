module Renalware
  log "--------------------Adding Appointments --------------------"

  file_path = File.join(File.dirname(__FILE__), "appointments.csv")

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    days_ahead = logcount.even? ? 30 : 40
    starts_at = Time.now + days_ahead.days
    starts_at_array = row["starts_at"].split(":")

    Clinics::Appointment.find_or_create_by!(
      starts_at: starts_at.change({ hour: starts_at_array[0], min: starts_at_array[1] }),
      patient: Clinics::Patient.find_by(local_patient_id: row["local_patient_id"]),
      user: User.find_by(username: row["username"]),
      clinic: Clinics::Clinic.find_by(name: row["clinic_name"])
    )
  end

  log "#{logcount} Appointments seeded"
end
