# frozen_string_literal: true

module Renalware
  log "Adding PD Training Sites" do

    file_path = File.join(File.dirname(__FILE__), "training_sites.csv")

    CSV.foreach(file_path, headers: true) do |row|
      PD::TrainingSite.find_or_create_by!(code: row["code"], name: row["name"])
    end
  end
end
