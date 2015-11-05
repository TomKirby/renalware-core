require "document/embedded"

module Renalware
  module Transplants
    class RegistrationDocument < Document::Embedded

      class Codes < Document::Embedded
        attribute :uk_transplant_centre_code
        attribute :uk_transplant_patient_recipient_number
      end
      attribute :codes, Codes

      class CRF < Document::Embedded
        attribute :highest, DatedResult
        attribute :latest, DatedResult
      end
      attribute :crf, CRF

      class Transplant < Document::Embedded
        attribute :blood_group
        attribute :nb_of_previous_grafts, Integer
        attribute :sens_status
      end
      attribute :transplant, Transplant

      class Organs < Document::Embedded
        attribute :transplant_type, enums: %i(kidney kidney_pancreas pancreas kidney_liver liver)
        attribute :pancreas_only_type, enums: %i(solid_organ islets)
        attribute :rejection_risk, enums: %i(low standard high individualised)
        attribute :also_listed_for_kidney_only, enums: %i(yes no unknown)
        attribute :to_be_listed_for_other_organs, enums: %i(yes no unknown)
        attribute :received_previous_kidney_or_pancreas_grafts, enums: %i(yes no unknown)
      end
      attribute :organs, Organs

      class Consent < Document::Embedded
        attribute :value, enums: %i(yes no unknown)
        attribute :consented_on, Date
        attribute :name

        validates :consented_on, timeliness: { type: :date, allow_blank: true }
        validates :consented_on, presence: true, if: "value.present?"
        validates :name, presence: true, if: "value.present?"
      end
      attribute :nhb_consent, Consent

      class HLA < Document::Embedded
        attribute :a, BinaryMarker
        attribute :b, BinaryMarker
        attribute :cw, BinaryMarker
        attribute :dr, BinaryMarker
        attribute :dq, BinaryMarker
        attribute :drw, BinaryMarker
        attribute :drq, BinaryMarker
        attribute :type
        attribute :recorded_on, Date
      end
      attribute :hla, HLA
    end
  end
end