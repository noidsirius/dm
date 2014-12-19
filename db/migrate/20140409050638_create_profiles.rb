class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.belongs_to :user

      t.string :first_name
      t.string :last_name
      t.date :birth_day
      t.boolean :is_female
      t.text :info
      t.text :about
      t.string :username

      t.timestamps
    end
  end
end
