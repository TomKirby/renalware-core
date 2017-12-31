require "rails_helper"

RSpec.describe "Hospital Wards", type: :request do
  describe "GET index json" do
    it "returns wards for a hospital unit, useful for example for inserting into a wards select " \
       "when the parent unit dropdown has changed" do

      unit = create(:hospital_unit)
      ward_a = create(:hospital_ward, name: "WardA", hospital_unit: unit)
      ward_b = create(:hospital_ward, name: "WardB", hospital_unit: unit)

      get hospitals_unit_wards_path(unit, format: :json)

      expect(response).to have_http_status(:success)
      wards = JSON.parse(response.body).map(&:symbolize_keys!)
      expect(wards).to eq(
        [
          { id: ward_a.id, name: ward_a.name },
          { id: ward_b.id, name: ward_b.name }
        ]
      )
    end
  end
end