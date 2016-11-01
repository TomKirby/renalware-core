module Renalware
  log "Adding Peritonitis Fluid Descriptions"

  PD::FluidDescription.find_or_create_by!(description: "Clear")
  PD::FluidDescription.find_or_create_by!(description: "Misty")
  PD::FluidDescription.find_or_create_by!(description: "Cloudy")
  PD::FluidDescription.find_or_create_by!(description: "Pea Soup")
end