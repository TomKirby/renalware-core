require "rails_helper"

module Renalware
  describe YAMLPermissionConfiguration, type: :policy do
    subject do
      YAMLPermissionConfiguration.new(model, Rails.root.join("spec", "fixtures", "permissions.yml"))
    end

    class ::FakeModel; end

    let(:model) { FakeModel }

    describe "#restricted?" do
      context "given a model has not been specified in the configuration" do
        let(:model) { ::FakeUnspecifiedModel = Class.new }

        it "returns false" do
          expect(subject.restricted?).to be false
        end
      end

      context "given a model has been specified in the configuration" do

        it "returns true" do
          expect(subject.restricted?).to be true
        end
      end
    end

    describe "#has_permission?" do
      context "given a user has not been assigned the role to manage the model" do
        let(:admin) { double(:admin, role_names: [:admin]) }

        it "returns false" do
          expect(subject.has_permission?(admin)).to be false
        end
      end

      context "given a user has been assigned the role to manage the model" do
        let(:super_admin) { double(:super_admin, role_names: [:super_admin]) }

        it "returns false" do
          expect(subject.has_permission?(super_admin)).to be true
        end
      end
    end
  end
end
