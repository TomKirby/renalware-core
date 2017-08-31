module Renalware

  log "Adding HD Stations" do

    class CreateStation
      attr_reader :units, :user

      def initialize
        @units = Hospitals::Unit.all
        @user = Renalware::User.first
      end

      def find_hd_unit_by_code(code)
        unit = units.select{ |un| un.unit_code == code }.first
        fail "Unit '#{code}' not found" if unit.nil?
        unit
      end

      def call(row)
        unit = find_hd_unit_by_code(row["unit_code"])
        station = HD::Station.find_or_initialize_by(
          name: row["name"],
          location: row["location"],
          hospital_unit_id: unit.id,
          position: row["position"]
        ).save_by!(user)
      end
    end

    file_path = File.join(File.dirname(__FILE__), "stations.csv")
    create_station = CreateStation.new

    CSV.foreach(file_path, headers: true) do |row|
      create_station.call(row)
    end
  end
end