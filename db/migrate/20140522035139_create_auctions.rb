class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.string :name
      t.integer :base_price
      t.datetime :start_time
      t.datetime :end_time
      t.integer :problem_id

      t.timestamps
    end
  end
end
