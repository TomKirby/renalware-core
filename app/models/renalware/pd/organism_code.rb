# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class OrganismCode < ApplicationRecord
      has_many :infection_organisms
      has_many :peritonitis_episodes,
               through: :infection_organisms,
               source: :infectable,
               source_type: "PeritonitisEpisode"
      has_many :exit_site_infections,
               through: :infection_organisms,
               source: :infectable,
               source_type: "ExitSiteInfection"
    end
  end
end
