require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::GlobalRule do

  it { is_expected.to validate_presence_of(:global_rule_set) }
  it do
    is_expected.to validate_inclusion_of(:param_comparison_operator)
      .in_array(described_class::PARAM_COMPARISON_OPERATORS)
  end

  let(:global_rule) { create(:pathology_request_algorithm_global_rule) }

  describe "#required_for_patient?" do
    let(:patient) { create(:patient) }
    let(:param_type_obj) do
      double(Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult)
    end
    let(:patient_requires_test) { double }

    before do
      allow(Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult).to receive(:new)
        .and_return(param_type_obj)
      allow(param_type_obj).to receive(:patient_requires_test?).and_return(patient_requires_test)
    end

    subject! { global_rule.required_for_patient?(patient) }

    it { is_expected.to eq(patient_requires_test) }
  end
end
