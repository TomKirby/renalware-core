# frozen_string_literal: true

require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class DonorFollowup < ApplicationRecord
      belongs_to :operation,
                 class_name: "DonorOperation",
                 foreign_key: "operation_id",
                 touch: true

      has_paper_trail class_name: "Renalware::Transplants::Version"

      validates :last_seen_on, timeliness: { type: :date, allow_blank: true }
      validates :dead_on, timeliness: { type: :date, allow_blank: true }
    end
  end
end
