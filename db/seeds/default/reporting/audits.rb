module Renalware
  #log "Adding default audits" do
    file_path = File.join(File.dirname(__FILE__), "audits.yml")
    yml_audits = YAML.load_file(file_path)
    yml_audits.each do |yml_audit|
      yml_audit.symbolize_keys!
      Reporting::Audit.find_or_create_by!(name: yml_audit[:name]) do |audit|
        audit.description = yml_audit[:description]
        audit.materialized_view_name = yml_audit[:materialized_view_name]
        audit.refresh_schedule = yml_audit[:refresh_schedule]
        audit.display_configuration = yml_audit[:display_configuration]
      end
    end
  #end
end