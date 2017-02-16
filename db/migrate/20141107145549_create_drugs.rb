class CreateDrugs < ActiveRecord::Migration[4.2]
  def change
    create_table :drugs do |t|
      t.string :name, null: false
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
