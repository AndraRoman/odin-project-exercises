class AddForeignKeyToPost < ActiveRecord::Migration
  def change
    add_column :posts, :user_id, :integer
    add_foreign_key :posts, :users, name: :user_id
  end
end
