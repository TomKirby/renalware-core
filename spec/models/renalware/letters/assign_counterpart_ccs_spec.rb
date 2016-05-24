require "rails_helper"

module Renalware
  module Letters
    RSpec.describe AssignCounterpartCCs, type: :model do
      include LettersSpecHelper

      subject { AssignCounterpartCCs.new(letter) }

      let(:patient) { build(:letter_patient) }

      describe "#call" do
        context "given the recipient is the patient" do
          let(:letter) { build_letter(to: :patient, patient: patient) }

          it "adds the doctor as a CC recipient" do
            subject.call
            expect(letter.cc_recipients.size).to eq(1)
            expect(letter.cc_recipients.first.person_role).to eq("doctor")
          end
        end

        context "given the recipient is the doctor" do
          let(:letter) { build_letter(to: :doctor, patient: patient) }

          context "given the patient opted to be CCd on all letters" do
            before do
              allow(letter.patient).to receive(:cc_on_letter?).and_return(true)
            end

            it "adds the patient as a CC recipient" do
              subject.call

              expect(letter.cc_recipients.size).to eq(1)
              expect(letter.cc_recipients.first.person_role).to eq("patient")
            end
          end

          context "given the patient did not opt to be CCd on all letters" do
            before do
              allow(letter.patient).to receive(:cc_on_letter?).and_return(false)
            end

            it "does not add the patient as a CC recipient" do
              subject.call

              expect(letter.cc_recipients).to be_empty
            end
          end
        end

        context "given the recipient is someone else" do
          let(:letter) { build_letter(to: :other, patient: patient) }

          context "given the patient opted to be CCd on all letters" do
            before do
              letter.patient.cc_on_all_letters = true
            end

            it "adds the patient and the doctor as CC recipients" do
              subject.call

              expect(letter.cc_recipients.size).to eq(2)
              person_roles = letter.cc_recipients.map(&:person_role)
              expect(person_roles).to include("patient")
              expect(person_roles).to include("doctor")
            end
          end
        end

        context "given the main recipient is changed from doctor to patient" do
          let(:letter) { build_letter(to: :doctor, patient: patient) }

          before do
            letter.cc_recipients.build(person_role: :patient)
            letter.main_recipient.person_role = :patient
            letter.by = letter.author
          end

          it "sets the doctor as the only CC recipient" do
            subject.call

            expect(letter.cc_recipients.size).to eq(1)
            expect(letter.cc_recipients.first.person_role).to eq("doctor")
          end
        end
      end
    end
  end
end