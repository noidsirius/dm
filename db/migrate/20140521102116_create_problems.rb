class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.text :Description
      t.integer :level_id

      t.timestamps
    end
  end
end
