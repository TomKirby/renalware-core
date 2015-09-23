module Renalware
  class Doctor < ActiveRecord::Base
    include Personable
    include ActiveModel::Validations

    belongs_to :address
    has_and_belongs_to_many :practices
    has_many :letters
    has_many :patients

    accepts_nested_attributes_for :address, reject_if: Address.reject_if_blank

    validates_with DoctorAddressValidator
    validates_with DoctorEmailValidator
    validates_uniqueness_of :code
    validates_presence_of :practitioner_type
  end
end