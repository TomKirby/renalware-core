module Renalware
  log "Adding Contact Descriptions"

  CSV.foreach(File.join(File.dirname(__FILE__),"contact_descriptions.csv"), headers: true) do |row|
    Letters::ContactDescription.find_or_create_by!(system_code: row["system_code"]) do |description|
      description.name = row["name"]
    end
  end
end
