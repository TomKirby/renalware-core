require "rails_helper"

module Renalware::Letters
  describe Letter::Typed do
    include LettersSpecHelper

    let(:user) { build(:user) }
    let(:doctor) { build(:letter_doctor) }
    let(:patient) { build(:letter_patient, doctor: doctor) }
    let(:letter) { build_letter(to: :patient, patient: patient) }

    subject(:typed_letter) { letter.becomes(Letter::Typed) }

    describe "#archive" do
      it "archives the letter" do
        archived_letter = typed_letter.archive(by: user, renderer: DummyHTMLRenderer)
        expect(archived_letter).to be_archived
      end

      it "records who archived the letter" do
        archived_letter = typed_letter.archive(by: user, renderer: DummyHTMLRenderer)
        expect(archived_letter.archived_by).to eq(user)
      end

      context "with persisted letter" do
        let(:doctor) { create(:letter_doctor) } # Doctor has to exist before saving a letter

        before do
          letter.save
        end

        it "archives the content" do
          archived_letter = typed_letter.archive(by: user)
          expect(archived_letter.content).to match(/class="letter-preview"/)
          expect(archived_letter.content).to include(patient.full_name)
        end
      end
    end

    class DummyHTMLRenderer
      def call(letter)
      end
    end
  end
end
