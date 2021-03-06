# frozen_string_literal: true

require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :profiles
      has_many :plans
      has_many :procedures
      has_many :assessments

      def current_profile
        profiles.current.first
      end

      def current_plan
        plans.current.first
      end
    end
  end
end
