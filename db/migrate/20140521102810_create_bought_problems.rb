class CreateBoughtProblems < ActiveRecord::Migration
  def change
    create_table :bought_problems do |t|
      t.integer :profile_id
      t.integer :problem_id

      t.timestamps
    end
  end
end
