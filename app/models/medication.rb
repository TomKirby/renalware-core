class Medication < ActiveRecord::Base
  attr_accessor :drug_select

  acts_as_paranoid

  has_paper_trail :class_name => 'MedicationVersion'

  belongs_to :patient
  belongs_to :medicatable, :polymorphic => true
  belongs_to :treatable, :polymorphic => true
  belongs_to :medication_route

  validates :patient, presence: true

  validates :medicatable, presence: { message: "Medication to be administered can't be blank" }
  validates :dose, presence: { message: "Dose can't be blank" }
  validates :medication_route_id, presence: { message: "Route can't be blank" }
  validates :frequency, presence: { message: "Frequency & Duration can't be blank" }
  validates :start_date, presence: { message: "Prescribed On can't be blank" }
  validates :provider, presence: { message: "Provider can't be blank" }

  enum provider: %i(gp hospital home_delivery)

end
