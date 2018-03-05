# frozen_string_literal: true

module Select2SpecHelper
  def select2(value, opts)
    scope = opts[:from]
    select2_container = first("#{scope} + .select2-container")
    select2_container.first(".select2-selection").click

    first("input.select2-search__field").set(value)
    page.execute_script(%|$("#{scope} ~ input.select2-search__field:visible").keyup();|)
    body = find(:xpath, "//body")
    matches = body.find_all(".select2-results li", text: value)
    matches.last.click
  end
end
