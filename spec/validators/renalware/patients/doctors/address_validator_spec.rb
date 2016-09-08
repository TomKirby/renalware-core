require "rails_helper"

module Renalware::Patients::Doctors
  describe AddressValidator do
    describe "validate" do
      it "validates an address is present on the Doctor" do
        doc = build_stubbed(:doctor)
        AddressValidator.new.validate(doc)
        expect(doc.errors[:address]).to match_array(["or practice must be present"])
      end

      it "does nothing when the doctor has an address" do
        doc = build_stubbed(:doctor, address: build_stubbed(:address), practices: [build_stubbed(:practice)])
        AddressValidator.new.validate(doc)
        expect(doc.errors[:address]).to be_empty
      end
    end
  end
end
