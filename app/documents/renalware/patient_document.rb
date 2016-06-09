require "document/embedded"
require "document/enum"

module Renalware
  class PatientDocument < Document::Embedded
    attribute :interpreter_notes, String
    attribute :admin_notes, String
    attribute :special_needs_notes, String

    class Address < Document::Embedded
      attribute :name, String
      attribute :organisation_name, String
      attribute :street_1, String
      attribute :street_2, String
      attribute :city, String
      attribute :county, String
      attribute :postcode, String
      attribute :country, String
    end

    class NextOfKin < Document::Embedded
      attribute :name, String
      attribute :telephone, String
      attribute :address, Address
    end
    attribute :next_of_kin, NextOfKin

    class Pharmacist < Document::Embedded
      attribute :name, String
      attribute :telephone, String
      attribute :address, Address
    end
    attribute :pharmacist, Pharmacist

    class DistrictNurse < Document::Embedded
      attribute :name, String
      attribute :telephone, String
      attribute :address, Address
    end
    attribute :district_nurse, DistrictNurse

    class Referral < Document::Embedded
      attribute :referring_physician_name, String
      attribute :referral_date, Date
      attribute :referral_type, String
      attribute :referral_notes, String
    end
    attribute :referral, Referral
  end
end