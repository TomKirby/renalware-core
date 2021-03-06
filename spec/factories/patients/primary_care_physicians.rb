# frozen_string_literal: true

FactoryBot.define do
  sequence :gp_code do |n|
    "GP1234#{n}"
  end

  factory :primary_care_physician, class: "Renalware::Patients::PrimaryCarePhysician" do
    name "GOOD PJ"
    telephone "0203593082"
    code { generate(:gp_code) }
    practitioner_type "GP"

    # ensures addressable_type and addressable_id work is assigned, using
    # FactoryBot's simple assoc method does not work
    #
    before(:create) do |primary_care_physician|
      primary_care_physician.build_address(attributes_for(:address))
    end
  end
end
