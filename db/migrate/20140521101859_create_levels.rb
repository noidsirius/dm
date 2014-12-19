class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name
      t.integer :price
      t.integer :bounty

      t.timestamps
    end
  end
end
