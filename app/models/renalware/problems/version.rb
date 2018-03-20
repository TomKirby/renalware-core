# frozen_string_literal: true

require_dependency "renalware/problems"

module Renalware
  module Problems
    class Version < PaperTrail::Version
      self.table_name = :problem_versions
    end
  end
end
