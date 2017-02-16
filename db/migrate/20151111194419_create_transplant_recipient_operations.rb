class CreateTransplantRecipientOperations < ActiveRecord::Migration[4.2]
  def change
    create_table :transplant_recipient_operations do |t|
      t.belongs_to :patient, index: true, foreign_key: true

      t.date :performed_on, null: false
      t.time :theatre_case_start_time, null: false
      t.datetime :donor_kidney_removed_from_ice_at, null: false
      t.string :operation_type, null: false
      t.references :hospital_centre, foreign_key: true, null: false
      t.datetime :kidney_perfused_with_blood_at, null: false
      t.integer :cold_ischaemic_time, null: false
      t.integer :warm_ischaemic_time, null: false
      t.text :notes

      t.jsonb :document

      t.timestamps null: false
    end

    add_index :transplant_recipient_operations, :document, using: :gin
  end
end
