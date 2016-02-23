class CreateProblemProblems < ActiveRecord::Migration
  def change
    create_table :problem_problems do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :description, null: false
      t.date :date
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end