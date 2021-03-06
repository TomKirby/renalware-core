class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.references :patient,    null: false, foreign_key: true
      t.datetime :date_time,    null: false
      t.references :event_type, foreign_key: true
      t.string :description
      t.text :notes
      t.timestamps null: false
    end
  end
end
