require_dependency "renalware/pd"

module Renalware
  module PD
    class PeritonitisEpisodeType < ActiveRecord::Base
      belongs_to :peritonitis_episode_type_description,
                 class_name: "PD::PeritonitisEpisodeTypeDescription"
      belongs_to :peritonitis_episode,
                 class_name: "PD::PeritonitisEpisode"
    end
  end
end
