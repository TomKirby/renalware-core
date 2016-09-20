module Renalware
  log '--------------------Adding Primary Renal Diagnosis (PRD) Codes--------------------'

  file_path = File.join(File.dirname(__FILE__), 'prd_descriptions.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Renal::PRDDescription.find_or_create_by!(code: row['code']) do |code|
      code.term = row['term']
    end
  end

  log "#{logcount} PRD Codes seeded"
end
