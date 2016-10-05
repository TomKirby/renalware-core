require_dependency "renalware/letters"

module Renalware
  module Letters
    class Contact < ActiveRecord::Base
      belongs_to :patient
      belongs_to :person, class_name: "Directory::Person"

      validates :person, presence: true, uniqueness: { scope: :patient,
        message: "the person must be unique to the patient" }

      delegate :address, :to_s, to: :person
      delegate :name, to: :address, prefix: true

      scope :with_person, -> { includes(:person) }

      def self.find_by_given_name(name)
        with_person.find_by(directory_people: { given_name: name })
      end
    end
  end
end
