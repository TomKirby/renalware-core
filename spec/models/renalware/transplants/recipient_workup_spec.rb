require "rails_helper"

module Renalware
  module Transplants
    describe RecipientWorkup do
      it { is_expected.to belong_to(:patient).touch(true) }
    end
  end
end
