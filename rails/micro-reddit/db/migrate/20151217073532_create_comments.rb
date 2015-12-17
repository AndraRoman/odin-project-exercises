class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.timestamps null: false
      t.integer :user_id, null: false
      t.integer :post_id, null: false
    end
    add_foreign_key :comments, :users, name: :user_id
    add_foreign_key :comments, :posts, name: :post_id
  end
end
