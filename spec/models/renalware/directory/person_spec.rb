# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Directory
    describe Person do
      it_behaves_like "an Accountable model"
      it { is_expected.to validate_presence_of(:given_name) }
      it { is_expected.to validate_presence_of(:family_name) }
    end
  end
end
