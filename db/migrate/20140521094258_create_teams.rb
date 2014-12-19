class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.belongs_to :contest
      t.belongs_to :profile
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
