require "rails_helper"

RSpec.describe Renalware::Admissions::Admission, type: :model do
  it { is_expected.to validate_presence_of :patient_id }
  it { is_expected.to validate_presence_of :hospital_ward_id }
  it { is_expected.to validate_presence_of :admitted_on }
  it { is_expected.to validate_presence_of :reason_for_admission }
  it { is_expected.to validate_presence_of :admission_type }
  it { is_expected.to respond_to(:by=) } # accountable
  it { is_expected.to belong_to(:patient) }
  it { is_expected.to belong_to(:hospital_ward) }
  it { is_expected.to belong_to(:modality_at_admission) }

  it "is paranoid" do
    expect(described_class).to respond_to(:deleted)
  end

  let(:modality_desc) { create(:hd_modality_description) }
  let(:user) { create(:user) }
  let(:patient) do
    create(:patient).tap do |pat|
      Renalware::Modalities::ChangePatientModality
        .new(patient: pat, user: user)
        .call(description: modality_desc, started_on: Time.zone.now)
    end.reload
  end

  describe "scope .currently_admitted" do
    it "returns only currently admitted patients" do
      create(
        :admissions_admission,
        patient: patient,
        discharged_on: "2017-12-12"
      ) # prev. admission
      current_admission = create(
        :admissions_admission,
        patient: patient,
        discharged_on: nil
      )

      expect(described_class.currently_admitted). to eq [current_admission]
    end
  end

  describe "scope .discharged_but_missing_a_summary" do
    it "returns only discharged patients who have no discharge summary yet" do
      create(
        :admissions_admission,
        patient: patient,
        discharged_on: "2017-12-12",
        discharge_summary: "discharge summary"
      )
      disch_without_summ = create(
        :admissions_admission,
        patient: patient,
        discharged_on: "2017-12-12",
        discharge_summary: nil
      )

      expect(described_class.discharged_but_missing_a_summary).to eq [disch_without_summ]
    end
  end
end