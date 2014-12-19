class CreateProblemChapters < ActiveRecord::Migration
  def change
    create_table :problem_chapters do |t|
      t.integer :problem_id
      t.integer :chapter_id

      t.timestamps
    end
  end
end
