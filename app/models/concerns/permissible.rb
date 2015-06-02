require 'active_support/concern'

module Permissible
  extend ActiveSupport::Concern

  included do
    class_eval do
      has_and_belongs_to_many :roles
    end

    def has_role?(name)
      !!roles.find_by(name: name)
    end

    def role_names
      roles.map { |r| r.name.humanize }
    end
  end
end