require_dependency "renalware"

module Renalware
  class AddressSingleLinePresenter < SimpleDelegator
    def to_s
      presentable_attrs
        .map(&:to_s)
        .reject(&:blank?)
        .join(", ")
    end

    private

    def presentable_attrs
      [
        street_1,
        street_2,
        city,
        county,
        postcode,
        ::Renalware::CountryPresenter.new(country)
      ]
    end
  end
end
