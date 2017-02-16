class CreateFeedMessages < ActiveRecord::Migration[4.2]
  def change
    create_table :feed_messages do |t|
      t.string :event_code, null: false
      t.string :header_id, null: false
      t.text :body, null: false
      t.timestamps null: false
    end
  end
end
