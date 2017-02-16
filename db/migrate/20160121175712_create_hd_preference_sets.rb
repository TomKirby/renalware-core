class CreateHDPreferenceSets < ActiveRecord::Migration[4.2]
  def change
    create_table :hd_preference_sets do |t|
      t.belongs_to :patient, index: true, foreign_key: true, null: false
      t.belongs_to :hospital_unit, index: true, foreign_key: true
      t.string :schedule
      t.string :other_schedule
      t.date :entered_on
      t.text :notes

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false

      t.timestamps null: false
    end
  end
end
