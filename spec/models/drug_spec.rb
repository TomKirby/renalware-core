require 'rails_helper'

RSpec.describe Drug, :type => :model do

  it { should have_many(:medications).dependent(:destroy) }
  it { should have_many(:patients).through(:medications) }
  it { should have_many(:drug_drug_types) }
  it { should have_many(:drug_types).through(:drug_drug_types) }

  subject { build(:drug) }

  describe 'destroy' do
    it 'soft deletes the drug' do
      subject.save!
      expect{ subject.destroy! }.to change(Drug,:count).by(-1)
      soft_deleted = Drug.with_deleted.find(subject.id)
      expect(soft_deleted).to eq(subject)
      expect(soft_deleted.deleted_at).not_to be_nil
    end
  end

  context 'assign drug types to a drug' do
    it 'can be assigned many unique drug types' do
      @antibiotic = create(:drug_type, name: 'Antibiotic')
      @esa = create(:drug_type, name: 'ESA')

      subject.drug_types << @antibiotic
      subject.drug_types << @antibiotic
      subject.drug_types << @esa

      subject.save!
      subject.reload

      expect(subject.drug_types.size).to eq(2)

      expect(subject).to be_valid
    end
  end
end
