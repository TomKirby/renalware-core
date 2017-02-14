class CreateEDTACodes < ActiveRecord::Migration[4.2]
  def change
    create_table :death_edta_codes do |t|
      t.integer :code
      t.string :death_cause
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
