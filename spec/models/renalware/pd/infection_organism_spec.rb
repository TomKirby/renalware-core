require 'rails_helper'

module Renalware
  RSpec.describe InfectionOrganism, :type => :model do
    it { should validate_presence_of(:organism_code) }
  end
end
