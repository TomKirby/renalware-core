module Renalware
  class PeritonitisEpisode < ActiveRecord::Base

    belongs_to :patient
    belongs_to :episode_type
    belongs_to :fluid_description

    has_many :medications, as: :treatable
    has_many :medication_routes, through: :medications
    has_many :patients, through: :medications, as: :treatable
    has_many :infection_organisms, as: :infectable
    has_many :organism_codes, -> { uniq }, through: :infection_organisms, as: :infectable

    accepts_nested_attributes_for :medications, allow_destroy: true
    accepts_nested_attributes_for :infection_organisms, allow_destroy: true

    validates :diagnosis_date, presence: true

  end
end