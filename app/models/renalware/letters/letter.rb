require_dependency "renalware/letters"

module Renalware
  module Letters
    class Letter < ActiveRecord::Base
      include Accountable
      extend Enumerize

      belongs_to :event, polymorphic: true
      belongs_to :author, class_name: "User"
      belongs_to :patient
      belongs_to :letterhead
      has_one :main_recipient, -> { where(role: "main") },
        class_name: "Recipient", inverse_of: :letter
      has_many :cc_recipients, -> { where(role: "cc") },
        class_name: "Recipient", dependent: :destroy, inverse_of: :letter
      has_many :recipients, dependent: :destroy
      has_one :signature, dependent: :destroy

      accepts_nested_attributes_for :main_recipient
      accepts_nested_attributes_for :cc_recipients, reject_if: :all_blank, allow_destroy: true

      validates :letterhead, presence: true
      validates :author, presence: true
      validates :patient, presence: true
      validates :issued_on, presence: true
      validates :description, presence: true
      validates :main_recipient, presence: true

      include ExplicitStateModel
      has_states :draft, :pending_review, :archived
      state_scope :reviewable, :pending_review

      scope :pending, -> { where(type: [state_class_name(:draft), state_class_name(:pending_review)]) }
      scope :reverse, -> { order(updated_at: :desc) }

      def self.policy_class
        LetterPolicy
      end

      def self.for_event(event)
        where(event: event).first
      end

      EVENTS_MAP = {
        Clinics::ClinicVisit => Event::ClinicVisit,
        NilClass => Event::Unknown
      }

      def letter_event
        @letter_event ||= EVENTS_MAP.fetch(event.class).new(event)
      end

      def doctor
        patient.doctor
      end

      def subject?(other_patient)
        patient == other_patient
      end

      def other_cc_recipients
        cc_recipients.select { |cc| cc.person_role.other? }
      end

      def determine_counterpart_ccs
        DetermineCounterpartCCs.new(self).call
      end

      def signed?
        signature.present?
      end
    end
  end
end
