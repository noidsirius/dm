class AddAttachmentToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :attachment, :string
  end
end
