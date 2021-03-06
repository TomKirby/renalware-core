# frozen_string_literal: true

# Uses acts_as_paranod to implement a meanss of deactivating and old and activating a
# new object such that there can only be one active object
# Enforcing only one active object requires an appropriate unique index to be created
# See https://github.com/rubysherpas/paranoia#unique-indexes
# Example migration:
#    add_column :hd_profiles, :deactivated_at, :datetime, index: true
#    add_column :hd_profiles, :active, :boolean, null: true, default: true
#    add_index :hd_profiles, [:active, :patient_id], unique: true
require "active_support/concern"

module Renalware
  module Supersedeable
    extend ActiveSupport::Concern

    included do
      class_eval do
        acts_as_paranoid column: :deactivated_at
      end

      def self.with_deactivated
        with_deleted
      end

      def supersede!(attrs = {})
        attrs = attrs.to_h unless attrs.is_a?(Hash)
        transaction do
          successor = dup
          destroy!
          successor.assign_attributes(attrs) if attrs.any?
          successor.save!
          successor
        end
      end

      # Unused?
      def paranoia_restore_attributes
        {
          deactivated_at: nil,
          active: true
        }
      end

      # Unused
      def paranoia_destroy_attributes
        {
          deactivated_at: current_time_from_proper_timezone,
          active: nil
        }
      end
    end
  end
end
