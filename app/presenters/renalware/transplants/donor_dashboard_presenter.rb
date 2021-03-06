# frozen_string_literal: true

require_dependency "renalware/transplants"
require "attr_extras"

module Renalware
  module Transplants
    class DonorDashboardPresenter
      attr_reader_initialize :patient

      def donor_stages
        @donor_stages ||= DonorStage.for_patient(patient).ordered
      end

      def donor_workup
        @donor_workups ||= DonorWorkup.for_patient(patient).first_or_initialize
      end

      def donations
        @donations ||= Donation.for_patient(patient).reversed
      end

      def donor_operations
        @donor_operations ||= DonorOperation.for_patient(patient).reversed
      end

      def investigations
        @investigations ||= begin
          Events::Investigation
            .for_patient(patient)
            .transplant_donors
            .ordered
        end
      end
    end
  end
end
