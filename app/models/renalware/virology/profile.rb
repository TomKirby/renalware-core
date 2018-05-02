# frozen_string_literal: true

require_dependency "renalware/virology"
require "document/base"

module Renalware
  module Virology
    class Profile < ApplicationRecord
      include Document::Base
      belongs_to :patient, touch: true
      has_document class_name: "Renalware::Virology::ProfileDocument"
    end
  end
end
