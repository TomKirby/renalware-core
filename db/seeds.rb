# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Patient.find_or_create_by!(:nhs_number => "1000124502") do |patient|
  patient.local_patient_id = "Z999999" 
  patient.surname = "RABBIT" 
  patient.forename = "R"
  patient.dob = "01/01/1947"
  patient.paediatric_patient_indicator = "1"
  patient.sex = "1"
  patient.ethnicity_id = 1
end

PatientEventType.find_or_create_by(name: "Other")
PatientEventType.find_or_create_by(name: "Access clinic")
PatientEventType.find_or_create_by(name: "Anaemia clinic")
PatientEventType.find_or_create_by(name: "CAPD Nurses clinic")
PatientEventType.find_or_create_by(name: "CAPD clinic")
PatientEventType.find_or_create_by(name: "Counsellor Meeting")
PatientEventType.find_or_create_by(name: "Dietitians clinic")
PatientEventType.find_or_create_by(name: "General Nephrology Clinic")
PatientEventType.find_or_create_by(name: "Haemodialysis clinic")
PatientEventType.find_or_create_by(name: "Home Haemodialysis clinic")
PatientEventType.find_or_create_by(name: "Iron clinic")
PatientEventType.find_or_create_by(name: "Low Clearance clinic")
PatientEventType.find_or_create_by(name: "Meeting with family")
PatientEventType.find_or_create_by(name: "MDM--Liver Renal Virology")
PatientEventType.find_or_create_by(name: "MDM--Renal Biopsy")
PatientEventType.find_or_create_by(name: "MDM--Radiology")
PatientEventType.find_or_create_by(name: "MDM--Renal Sickle")
PatientEventType.find_or_create_by(name: "Physiotherapist")
PatientEventType.find_or_create_by(name: "Research visit")
PatientEventType.find_or_create_by(name: "Result Review")
PatientEventType.find_or_create_by(name: "Social Worker")
PatientEventType.find_or_create_by(name: "Telephone call")
PatientEventType.find_or_create_by(name: "Email")
PatientEventType.find_or_create_by(name: "Transplant clinic")
PatientEventType.find_or_create_by(name: "Walk-in clinic")
PatientEventType.find_or_create_by(name: "Ward round")
PatientEventType.find_or_create_by(name: "Dartford Outreach Clinic")
PatientEventType.find_or_create_by(name: "Woolwich Outreach Clinic")
PatientEventType.find_or_create_by(name: "Plasma Exchange")
PatientEventType.find_or_create_by(name: "Tx Coordination")

Ethnicity.find_or_create_by(name: "White")
Ethnicity.find_or_create_by(name: "Black Caribbean")
Ethnicity.find_or_create_by(name: "Black African")
Ethnicity.find_or_create_by(name: "Black/other/non-mixed origin")
Ethnicity.find_or_create_by(name: "Indian")
Ethnicity.find_or_create_by(name: "Pakistani")
Ethnicity.find_or_create_by(name: "Bangladeshi")
Ethnicity.find_or_create_by(name: "Chinese")
Ethnicity.find_or_create_by(name: "Black British")
Ethnicity.find_or_create_by(name: "Black Caribbean")
Ethnicity.find_or_create_by(name: "Black North African")
Ethnicity.find_or_create_by(name: "Black--other African country")
Ethnicity.find_or_create_by(name: "Black East African Asian")
Ethnicity.find_or_create_by(name: "Black Indian sub-continent")
Ethnicity.find_or_create_by(name: "Black--other Asian")
Ethnicity.find_or_create_by(name: "Black Black - other")
Ethnicity.find_or_create_by(name: "Black--other/mixed")
Ethnicity.find_or_create_by(name: "Other Black--Black/White origin")
Ethnicity.find_or_create_by(name: "Other Black--Black/Asian origin")
Ethnicity.find_or_create_by(name: "Other ethnic non-mixed (NMO)")
Ethnicity.find_or_create_by(name: "British ethnic minority spec.(NMO)")
Ethnicity.find_or_create_by(name: "British ethnic minority unsp (NMO)")
Ethnicity.find_or_create_by(name: "Caribbean Island (NMO)")
Ethnicity.find_or_create_by(name: "North African Arab (NMO)")
Ethnicity.find_or_create_by(name: "Other African countries (NMO)")
Ethnicity.find_or_create_by(name: "East African Asian (NMO)")
Ethnicity.find_or_create_by(name: "Indian sub-continent (NMO)")
Ethnicity.find_or_create_by(name: "Other Asian (NMO)")
Ethnicity.find_or_create_by(name: "Irish (NMO)")
Ethnicity.find_or_create_by(name: "Greek Cypriot (NMO)")
Ethnicity.find_or_create_by(name: "Turkish Cypriot (NMO)")
Ethnicity.find_or_create_by(name: "Other European (NMO)")
Ethnicity.find_or_create_by(name: "Other ethnic NEC (NMO)")
Ethnicity.find_or_create_by(name: "Other ethnic/mixed origin")
Ethnicity.find_or_create_by(name: "Other ethnic/Black/White origin")
Ethnicity.find_or_create_by(name: "Other ethnic/Asian/White origin")
Ethnicity.find_or_create_by(name: "Other ethnic/mixed white origin")
Ethnicity.find_or_create_by(name: "Other ethnic/other mixed origin")
Ethnicity.find_or_create_by(name: "Refused")


