require "rails_helper"

module Renalware
  RSpec.describe PD::BagType, type: :model do
    it { should validate_presence_of :manufacturer }
    it { should validate_presence_of :description }
    it { should validate_presence_of :glucose_content }

    it do
      should validate_numericality_of(:glucose_content)
              .is_greater_than_or_equal_to(0)
              .is_less_than_or_equal_to(50)
              .allow_nil
    end

    describe "full_description" do
      it "concatenates manufacturer and description values" do
        bag_type = build(:bag_type, manufacturer: "Acme", description: "Wunderdrug 2000")
        expect(bag_type.full_description).to eq("Acme Wunderdrug 2000")
      end
    end
  end
end
