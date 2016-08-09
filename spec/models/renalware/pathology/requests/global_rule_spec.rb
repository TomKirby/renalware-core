require "rails_helper"

describe Renalware::Pathology::Requests::GlobalRule do
  it { is_expected.to validate_presence_of(:global_rule_set) }
  it do
    is_expected.to validate_inclusion_of(:param_comparison_operator)
      .in_array(Renalware::Pathology::Requests::GlobalRule::PARAM_COMPARISON_OPERATORS)
  end

  subject(:rule) { create(:pathology_requests_global_rule, param_type: "Fake") }

  describe "#required_for_patient?" do
    let(:patient) { create(:patient) }

    subject(:rule_required?) { rule.required_for_patient?(patient) }

    it { expect(rule_required?).to be_truthy }
  end
end

class Renalware::Pathology::Requests::ParamType::Fake
  def initialize(*_args); end

  def required?
    true
  end
end