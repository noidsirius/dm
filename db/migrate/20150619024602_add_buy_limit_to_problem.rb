class AddBuyLimitToProblem < ActiveRecord::Migration
  def change
    add_column :problems, :buy_limit, :integer, :default => 5
  end
end
