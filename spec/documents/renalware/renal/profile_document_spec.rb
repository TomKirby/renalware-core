require "rails_helper"

module Renalware
  module Renal
    describe ProfileDocument, type: :model do
      it { is_expected.to respond_to(:comorbidities) }
    end
  end
end
