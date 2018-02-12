require "rails_helper"

module Renalware
  describe PatientDocument, type: :model do
    it { is_expected.to respond_to(:history) }
    it { is_expected.to respond_to(:referral) }
    it { is_expected.to respond_to(:psychosocial) }
  end
end
