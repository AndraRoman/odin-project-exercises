class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string  :title
      t.text    :content
      t.integer :user_id

      t.timestamps null: false
    end

    add_foreign_key "posts", "users", name: "user_id"
  end
end
