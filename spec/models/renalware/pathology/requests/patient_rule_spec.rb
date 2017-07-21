require "rails_helper"

describe Renalware::Pathology::Requests::PatientRule do
  it { is_expected.to validate_presence_of(:lab) }
  it { is_expected.to validate_presence_of(:test_description) }
  it { is_expected.to validate_presence_of(:frequency_type) }
  it { is_expected.to validate_presence_of(:patient_id) }
  it do
    is_expected.to validate_inclusion_of(:frequency_type)
      .in_array(Renalware::Pathology::Requests::Frequency.all_names)
  end

  subject(:patient_rule) do
    create(
      :pathology_requests_patient_rule,
      patient: patient,
      start_date: Date.parse("2016-04-19"),
      end_date: Date.parse("2016-04-21"),
      frequency_type: "Always"
    )
  end

  let(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }

  describe "#required?" do
    context "given the specified date is not within the patient_rule's start/end date range" do
      let(:date) { Date.parse("2016-04-22") }

      it "returns false" do
        expect(patient_rule).not_to be_required(date)
      end
    end

    context "given specified date is within the patient_rule's start/end date range" do
      let(:date) { Date.parse("2016-04-20") }

      it "returns true" do
        expect(patient_rule).to be_required(date)
      end

      context "given the patient was previously observed" do
        let!(:request) { create_request(patient: patient, observed_on: "2016-04-19") }

        it "returns true" do
          expect(patient_rule).to be_required(date)
        end

        def create_request(patient:, observed_on:)
          create(
            :pathology_requests_request,
            clinic: create(:clinic),
            patient: patient,
            consultant: create(:pathology_consultant),
            created_at: observed_on
          )
        end
      end
    end
  end
end
