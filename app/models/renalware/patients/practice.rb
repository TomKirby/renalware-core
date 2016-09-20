require_dependency "renalware/patients"

module Renalware
  module Patients
    class Practice < ActiveRecord::Base
      has_one :address, as: :addressable

      accepts_nested_attributes_for :address, allow_destroy: true

      validates_presence_of :name
      validates_presence_of :address
      validates_presence_of :code
    end
  end
end