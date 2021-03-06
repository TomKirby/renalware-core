class CreateProblemNotes < ActiveRecord::Migration[4.2]
  def change
    create_table :problem_notes do |t|
      t.belongs_to :problem, index: true
      t.text :description, null: false

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :problem_notes, :problem_problems, column: :problem_id
  end
end
