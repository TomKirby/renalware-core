require "rails_helper"

RSpec.describe "API request for a single UKRDC patient XML document", type: :request do
  let(:user) { create(:user) }
  let(:algeria) { create(:algeria) }
  let(:uk) { create(:united_kingdom) }
  let(:english) { create(:language, :english) }
  let(:white_british) { create(:ethnicity, :white_british) }

  def validate(document, schema_path, root_element)
    xsddoc = Nokogiri::XML(File.read(schema_path), schema_path)
    schema = Nokogiri::XML::Schema.from_document(xsddoc)
    schema.validate(document)
  end

  def clinic_patient(patient)
    Renalware::Clinics.cast_patient(patient)
  end

  def clinical_patient(patient)
    Renalware::Clinical.cast_patient(patient)
  end

  describe "GET #show" do
    it "renders the correct UK RDC XML" do
      patient = create(
        :patient,
        ethnicity: white_british,
        country_of_birth: uk,
        language: english
      )
      patient.document.history.smoking = :ex
      patient.practice = create(:practice)
      patient.primary_care_physician = create(:primary_care_physician)
      patient.update!(by: user)
      create(:clinic_visit, patient: clinic_patient(patient))
      create(:allergy, patient: clinical_patient(patient), by: user)

      hd_patient = Renalware::HD.cast_patient(patient)
      create(:hd_closed_session, patient: hd_patient)

      # So medications elements are triggered
      create(:prescription, patient: patient, by: user)

      get api_ukrdc_patient_path(patient)

      expect(response).to be_success
      document = Nokogiri::XML(response.body)
      xsd_path = File.join(Renalware::Engine.root, "vendor", "xsd", "ukrdc/Schema/UKRDC.xsd")
      validate(document, xsd_path, "PatientRecord").each do |error|
        p error.message
        fail
      end
    end
  end
end
