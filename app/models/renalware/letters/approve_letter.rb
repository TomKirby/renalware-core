# frozen_string_literal: true

require_dependency "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    class ApproveLetter
      include Broadcasting
      pattr_initialize :letter

      class << self
        alias_method :build, :new
      end

      def call(by:)
        Letter.transaction do
          sign(by: by)
          archive_content(by: by)
          archive_recipients
          broadcast(:letter_approved, letter)
        end
      end

      private

      def sign(by:)
        # Needs to be saved before changing the STI type (signature would be lost otherwise)
        letter.sign(by: by).save!
      end

      # Note that generate_archive returns the letter as a Letter::Approved object.
      # We need to update our letter reference as it's this Approved letter we need to broadcast
      # to subscribers.
      def archive_content(by:)
        @letter = letter.generate_archive(by: by)
        letter.save!
      end

      def archive_recipients
        letter.archive_recipients!
      end
    end
  end
end
