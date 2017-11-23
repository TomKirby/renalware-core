module Renalware
  class User < ApplicationRecord
    include Deviseable
    include Personable

    has_and_belongs_to_many :roles, join_table: :roles_users

    validates :username, presence: true, uniqueness: true
    validates :given_name, presence: true
    validates :family_name, presence: true
    validate :approval_with_roles, on: :update
    validates_presence_of :professional_position,
                          on: :update,
                          unless: :skip_validation
    validates_presence_of :signature,
                          on: :update,
                          unless: :skip_validation

    scope :unapproved, -> { where(approved: [nil, false]) }
    scope :inactive, lambda {
      where("last_activity_at IS NOT NULL AND last_activity_at < ?", expire_after.ago)
    }
    scope :author, -> { where.not(signature: nil) }
    scope :ordered, -> { order(:family_name, :given_name) }

    # Non-persistent attribute to signify an update by an admin (bypassing some validations)
    attr_accessor :super_admin_update

    def skip_validation
      super_admin_update || reset_password_token
    end

    def self.policy_class
      UserPolicy
    end

    def self.ransackable_scopes(_auth_object = nil)
      %i(unapproved inactive)
    end

    def has_role?(name)
      role_names.include?(name.to_s)
    end

    def role_names
      @role_names ||= roles.pluck(:name)
    end

    # Official name for use when displaying e.g. on a letter. For example:
    #   Dr Isaac Newton (Consultant Gravitationalist)
    def professional_signature
      signed = signature || full_name
      signed += " (#{professional_position})" if professional_position?
      signed
    end

    private

    def approval_with_roles
      if approved? && roles.empty?
        errors.add(:approved, "approved users must have a role")
      end
    end
  end
end
