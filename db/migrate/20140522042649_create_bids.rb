class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :profile_id
      t.integer :auction_id
      t.integer :price
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
