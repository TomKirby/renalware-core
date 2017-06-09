require "rails_helper"

module Renalware
  module Transplants
    describe DonorFollowup do
      it { is_expected.to belong_to(:operation).touch(true) }
      it { is_expected.to validate_timeliness_of(:last_seen_on) }
      it { is_expected.to validate_timeliness_of(:dead_on) }
    end
  end
end
