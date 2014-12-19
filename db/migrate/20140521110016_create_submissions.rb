class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :profile_id
      t.integer :problem_id
      t.integer :status , default: 0
      t.text :description

      t.timestamps
    end
  end
end
