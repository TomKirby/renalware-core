require 'rails_helper'

RSpec.describe InfectionOrganism, :type => :model do
  it { should belong_to(:organism_code) }
  it { should belong_to(:infectable) }

  it { should validate_presence_of :infectable_id }
  it { should validate_presence_of :infectable_type }
  it { should validate_uniqueness_of(:organism_code_id).scoped_to([:infectable_id, :infectable_type]) }
  it { should validate_presence_of(:organism_code_id).with_message("Organism can't be blank") }
end
