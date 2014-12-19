class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :amount, default: 0
      t.integer :profile_id

      t.timestamps
    end
  end
end
