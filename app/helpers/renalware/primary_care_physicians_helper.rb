require_dependency "renalware"

module Renalware
  module PrimaryCarePhysiciansHelper
    def practices_options_for_select(primary_care_physician)
      selected_ids = primary_care_physician.practices.map(&:id)
      options_from_collection_for_select(Patients::Practice.all, :id, :name, selected_ids)
    end

    def practices_or_address(primary_care_physician)
      if primary_care_physician.practices.any?
        return practices_list(primary_care_physician.practices)
      end
      if primary_care_physician.address.present?
        return format_address(primary_care_physician.address)
      end
    end

    private

    def format_address(address)
      AddressPresenter::Short.new(address)
    end

    def practices_list(practices)
      practice_links = practices.map { |p| link_to(p.name, '#', title: format_address(p.address)) }
      practice_links.join(tag(:br)).html_safe
    end
  end
end
