module Renalware
  log '--------------------Adding PD Bag Types--------------------'
  file_path = File.join(default_path, 'bag_types.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    PD::BagType.find_or_create_by!(
      description: row['description'],
      manufacturer: row['manufacturer'],
      glucose_grams_per_litre: row['glucose_grams_per_litre'],
      amino_acid: row['amino_acid'],
      icodextrin: row['icodextrin'],
      low_glucose_degradation: row['low_glucose_degradation'],
      low_sodium: row['low_sodium'],
      sodium_mmole_l: row['sodium_mmole_l'],
      lactate_mmole_l: row['lactate_mmole_l'],
      bicarbonate_mmole_l: row['bicarbonate_mmole_l'],
      calcium_mmole_l: row['calcium_mmole_l'],
      magnesium_mmole_l: row['magnesium_mmole_l']
    )
  end

  log "#{logcount} Bag Types seeded"
end
