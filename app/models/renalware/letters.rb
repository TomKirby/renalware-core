# frozen_string_literal: true

require_dependency "renalware"
require_dependency "renalware/letters/author"

module Renalware
  module Letters
    def self.table_name_prefix
      "letter_"
    end

    def self.cast_author(user)
      ActiveType.cast(user, Author)
    end

    def self.cast_typist(user)
      ActiveType.cast(user, Typist)
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Letters::Patient)
    end

    def self.cast_primary_care_physician(primary_care_physician)
      ActiveType.cast(primary_care_physician, ::Renalware::Letters::PrimaryCarePhysician)
    end

    module Delivery
    end
  end
end
