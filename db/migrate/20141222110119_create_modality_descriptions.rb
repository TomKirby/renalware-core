class CreateModalityDescriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :modality_descriptions do |t|
      t.string :name, null: false
      t.string :type
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
