class CreateModalityReasons < ActiveRecord::Migration[4.2]
  def change
    create_table :modality_reasons do |t|
      t.string :type
      t.integer :rr_code
      t.string :description
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
