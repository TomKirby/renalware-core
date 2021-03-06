# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients::PrimaryCarePhysicians
    class AddressValidator < ActiveModel::Validator
      def validate(record)
        return if record.address.present? && record.address.valid?
        return if record.practices.any? && record.practices.map(&:address).any?

        record.errors[:address] << "or practice must be present"
      end
    end
  end
end
