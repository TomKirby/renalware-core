# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    RSpec.describe RecipientPresenter::WithCurrentAddress, type: :model do
      include LettersSpecHelper

      subject(:presenter) { RecipientPresenter::WithCurrentAddress.new(recipient) }

      let(:practice) do
        build(:practice).tap{ |prac| prac.build_address(attributes_for(:address)) }
      end
      let(:patient) { build(:letter_patient, practice: practice) }
      let(:recipient) { letter.main_recipient }

      describe "#address" do
        context "when the recipient's role is patient" do
          let(:letter) { build_letter(to: :patient, patient: patient) }

          it "returns the address of the patient" do
            expect(presenter.address).to eq(letter.patient.current_address)
          end
        end

        context "when the recipient's role is Primary Care Physician" do
          let(:letter) { build_letter(to: :primary_care_physician, patient: patient) }

          it "returns the address of the Practice" do
            expect(presenter.address).to eq(letter.patient.practice.address)
          end
        end

        context "when the recipient's role is contact" do
          let(:letter) { build_letter(to: :contact, patient: patient) }

          it "returns the recipient's address" do
            expect(presenter.address).to eq(recipient.current_address)
          end
        end
      end
    end
  end
end
