require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class DonorWorkup < ApplicationRecord
      include Document::Base
      include PatientScope

      belongs_to :patient, touch: true

      has_paper_trail class_name: "Renalware::Transplants::Version"
      has_document class_name: "Renalware::Transplants::DonorWorkupDocument"
    end
  end
end
