module Renalware
  module LayoutHelper
    def within_admin_layout(title: nil, **opts)
      within_layout(layout: "renalware/layouts/non_patient",
                    title: title,
                    **opts) { yield }
    end

    def within_patient_layout(title: nil, **opts)
      within_layout(layout: "renalware/layouts/patient",
                    title: title,
                    **opts) { yield }
    end

    def within_layout(layout:, title: nil, **opts)
      title ||= t?(".page_title") ? t(".page_title") : t(".title", cascade: false)
      opts[:title] = title
      render(layout: layout, locals: opts) { yield }
    end

    def generate_page_title(local_assigns:,
                            patient: nil,
                            separator: Renalware.config.page_title_spearator)
      parts = []
      parts << "#{patient} #{patient.age}y #{patient.sex}" if patient.present?
      parts << Array(local_assigns[:breadcrumbs]).map(&:title)
      parts << local_assigns[:title]
      title = parts.flatten.compact.join(separator)
      content_for(:page_title){ title }
      title
    end

    # Example usage for the edit patient (demographics) page
    # breadcrumbs_and_title(
    #   breadcrumbs: [
    #     Renalware::Breadcrumb.new(title: "Demographics",
    #                               anchor: link_to("Demographics", patient_path)
    #   ],
    #   title: "Edit"
    # )
    # Returns
    #   Demographics / Edit
    # where Demographics is a link back in the navigation, like a true breadcrumb.
    # :breadcrumbs can be anchors or just a page name, and is single does not need to be an array.
    # :title is normally just a string as it represents the current page, and should not be a link.
    def breadcrumbs_and_title(breadcrumbs: [], title:)
      Array(breadcrumbs).map(&:anchor).append(title).join(" / ").html_safe
    end

    def breadcrumbs_and_title1(local_assigns)
      breadcrumbs = local_assigns[:breadcrumbs]
      title = local_assigns[:title]
      Array(breadcrumbs).map(&:anchor).append(title).join(" / ").html_safe
    end
  end
end