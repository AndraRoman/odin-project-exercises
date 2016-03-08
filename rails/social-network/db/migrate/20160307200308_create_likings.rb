class CreateLikings < ActiveRecord::Migration
  def change
    create_table :likings do |t|
      t.integer "user_id", null: false
      t.integer "post_id", null: false
      t.index ["post_id", "user_id"], unique: true

      t.timestamps null: false
    end

    add_foreign_key "likings", "users", name: "user_id"
    add_foreign_key "likings", "posts", name: "post_id"
  end
end
