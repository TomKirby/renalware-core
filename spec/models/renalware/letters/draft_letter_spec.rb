require "rails_helper"

module Renalware
  module Letters
    RSpec.describe DraftLetter, type: :model do
      let(:patient) { create(:letter_patient, cc_on_all_letters: false) }

      describe ".call" do
        it "sets up the letter" do
          stub_persistancy

          subject.call(patient, description: "Foo")
            .on(:draft_letter_successfull) do |letter|
              expect(letter.description).to eq("Foo")
            end
        end

        it "persists the letter" do
          expect(PersistLetter).to receive(:build).and_return(double.as_null_object)

          subject.call(patient)
        end

        context "when letter is persisted" do
          it "broadcasts :draft_letter_successfull" do
            stub_persistancy

            expect_subject_to_broadcast(:draft_letter_successful, instance_of(Letter))

            subject.call(patient)
          end
        end

        context "when letter cannot be persisted" do
          it "broadcasts :draft_letter_failed" do
            service = double
            allow(service).to receive(:call).and_raise(ActiveRecord::RecordInvalid.new(Letter.new))
            allow(PersistLetter).to receive(:build).and_return(service)

            expect_subject_to_broadcast(:draft_letter_failed, instance_of(Letter))

            subject.call(patient)
          end
        end
      end

      def stub_persistancy
        allow(PersistLetter).to receive(:build).and_return(double.as_null_object)
      end

      def expect_subject_to_broadcast(*args)
        expect(subject).to receive(:broadcast).with(*args)
      end
    end
  end
end