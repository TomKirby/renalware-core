require "rails_helper"

module Renalware::Patients::Doctors
  describe EmailValidator do
    describe "validate" do
      it "validates an email is present on the Doctor" do
        doc = build_stubbed(:doctor, email: nil)
        EmailValidator.new.validate(doc)
        expect(doc.errors[:email]).to match_array(["or an email address for a practice must be present"])
      end

      it "does nothing when the doctor has an email" do
        doc = build_stubbed(:doctor, practices: [build_stubbed(:practice)])
        EmailValidator.new.validate(doc)
        expect(doc.errors[:email]).to be_empty
      end
    end
  end
end
