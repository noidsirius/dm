class CreateFollowLists < ActiveRecord::Migration
  def change
    create_table :follow_lists do |t|
      t.column :followee_id, :integer
      t.column :follower_id, :integer
      t.timestamps
    end
  end
end
