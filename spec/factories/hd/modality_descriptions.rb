# frozen_string_literal: true

FactoryBot.define do
  factory :hd_modality_description, class: "Renalware::HD::ModalityDescription" do
    initialize_with { Renalware::HD::ModalityDescription.find_or_create_by(name: "HD") }
  end
end
