module Renalware
  module Transplants
    class DonorWorkup < ActiveRecord::Base
      include Document::Base
      include PatientScope

      belongs_to :patient

      has_paper_trail class_name: "Renalware::Transplants::DonorWorkupVersion"
      has_document class_name: "DonorWorkupDocument"
    end
  end
end
