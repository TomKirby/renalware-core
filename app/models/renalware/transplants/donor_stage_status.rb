# frozen_string_literal: true

require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class DonorStageStatus < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      validates :position, presence: true

      def to_s
        name
      end
    end
  end
end
