class CreateTransplantFailureCauseDescriptionGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :transplant_failure_cause_description_groups do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
