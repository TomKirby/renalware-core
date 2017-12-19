class CreateAdmissionInpatients < ActiveRecord::Migration[5.1]
  def change
    create_table :admission_discharge_destinations do |t|
      t.string :destination, null: false
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    create_table :admission_inpatients do |t|
      t.references :hospital_unit, foreign_key: true, index: true
      t.references :hospital_ward, foreign_key: true, index: true
      t.references :patient, foreign_key: true, index: true, null: false
      t.date :admitted_on, null: false
      t.string :admission_type, null: false
      t.string :consultant
      t.string :modality
      t.text :reason_for_admission, null: false
      t.text :notes
      t.date :transferred_on
      t.string :transferred_to
      t.date :discharged_on
      t.integer :destination_id, index: true
      t.string :other_destination
      t.text :discharge_summary
      t.date :summarised_on
      t.references :summarised_by, foreign_key: { to_table: :users }, index: true
      t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
      t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_foreign_key :admission_inpatients, :admission_discharge_destinations, column: :destination_id
  end
end
