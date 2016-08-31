require "rails_helper"

describe Renalware::Pathology::Requests::GlobalRule::ObservationResult do
  let(:klass) { Renalware::Pathology::Requests::GlobalRule::ObservationResult }

  describe "#observation_description_present" do
    include_context "a global_rule_set"

    context "with a valid observation_description" do
      let(:observation_description) { create(:pathology_observation_description) }

      subject(:global_rule) do
        klass.new(
          rule_set: global_rule_set,
          param_id: observation_description.id,
          param_comparison_operator: "<",
          param_comparison_value: 100
        )
      end

      it { expect(global_rule).to be_valid }
    end

    context "with an invalid observation_description" do
      subject(:global_rule) do
        klass.new(
          rule_set: global_rule_set,
          param_id: nil,
          param_comparison_operator: "<",
          param_comparison_value: 100
        )
      end

      it { expect(global_rule).to be_invalid }
    end
  end
end