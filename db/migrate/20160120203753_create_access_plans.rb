class CreateAccessPlans < ActiveRecord::Migration[4.2]
  def change
    create_table :access_plans do |t|
      t.string :name, null: false
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
