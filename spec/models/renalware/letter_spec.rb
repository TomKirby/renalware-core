require 'rails_helper'

module Renalware
  describe Letter, type: :model do
    subject { create(:letter) }
    it { should belong_to :author }
    it { should belong_to :reviewer }
    it { should belong_to :doctor }
    it { should belong_to :patient }
    it { should belong_to :letter_description }
    it { should validate_presence_of :letter_description_id }
    it { should validate_presence_of :recipient }
    it { should validate_presence_of :recipient_address }
    it { should validate_presence_of :state }

    describe 'title' do
      it 'titleizes the class name' do
        expect(subject.title).to eq('Letter')
      end
    end
  end
end