# frozen_string_literal: true

require "rails_helper"

module Renalware::HD
  RSpec.describe Diary, type: :model do
    it_behaves_like "an Accountable model"
    it { is_expected.to validate_presence_of(:hospital_unit_id) }
    it { is_expected.to have_many(:slots) }
  end
end
