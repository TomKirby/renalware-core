require_dependency "renalware"
require_dependency "renalware/feeds"
require "subscription_registry"

module Renalware
  module Pathology
    module_function

    def table_name_prefix
      "pathology_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Pathology::Patient)
    end

    def self.cast_user_to_consultant(user)
      ActiveType.cast(user, ::Renalware::Pathology::Consultant)
    end

    def configure
      SubscriptionRegistry.instance.register(Feeds::MessageProcessor, MessageListener)
    end
  end
end
