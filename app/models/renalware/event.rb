module Renalware
  class Event < ActiveRecord::Base
    belongs_to :patient
    belongs_to :event_type

    validates :patient, :event_type, :date_time, :description, :notes, :presence => true

  end
end