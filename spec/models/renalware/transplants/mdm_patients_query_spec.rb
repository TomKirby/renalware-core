# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Transplants
    describe MDMPatientsQuery do
      it { is_expected.to respond_to(:call) }
      it { is_expected.to respond_to(:search) }
    end
  end
end
