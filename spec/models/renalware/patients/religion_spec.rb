require "rails_helper"

module Renalware
  module Patients
    describe Religion do
      it { is_expected.to validate_presence_of :name }
    end
  end
end
