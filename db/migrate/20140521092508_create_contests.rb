class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.belongs_to :profile

      t.string :title
      t.text :description
      t.datetime :release_time
      t.boolean :finished
      t.time :duration

      t.timestamps
    end
  end
end
