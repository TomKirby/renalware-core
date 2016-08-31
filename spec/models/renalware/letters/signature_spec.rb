require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Signature, type: :model do
      it { is_expected.to validate_presence_of(:user) }
      it { is_expected.to validate_presence_of(:letter) }
      it { is_expected.to validate_presence_of(:signed_at) }

      describe "#to_s" do
        let(:user) { build(:user, family_name: "Doe", given_name: "John")}
        subject(:signature) { Signature.new(user: user, signed_at: "2016-08-01 12:05:55") }

        it "returns a signature line" do
          expect(signature.to_s).to eq("ELECTRONICALLY SIGNED BY JOHN DOE AT 12:05 ON 01-08-2016")
        end
      end
    end
  end
end