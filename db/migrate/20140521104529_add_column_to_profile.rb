class AddColumnToProfile < ActiveRecord::Migration
  def change
    add_column Profile, :credit, :integer
  end
end
