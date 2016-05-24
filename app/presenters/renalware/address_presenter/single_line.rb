require_dependency "renalware/address_presenter"

module Renalware
  class AddressPresenter::SingleLine < AddressPresenter
    private

    def presentable_attrs
      [
        street_1,
        street_2,
        city,
        county,
        postcode,
        country
      ]
    end
  end
end