class CreateClinicVisits < ActiveRecord::Migration[4.2]
  def change
    create_table :clinic_visits do |t|
      t.belongs_to :patient, index: true
      t.datetime :date, null: false
      t.float :height
      t.float :weight
      t.integer :systolic_bp
      t.integer :diastolic_bp
      t.string :urine_blood
      t.string :urine_protein
      t.text :notes
      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false
      t.timestamps null: false
    end
  end
end
