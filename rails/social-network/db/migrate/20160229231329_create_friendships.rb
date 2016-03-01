class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer "initiator_id", null: false
      t.integer "recipient_id", null: false
      t.boolean "confirmed", null: false, default: false

      t.timestamps null: false
    end

    add_index "friendships", "initiator_id"
    add_index "friendships", "recipient_id"

    add_foreign_key "friendships", "users", column: "initiator_id"
    add_foreign_key "friendships", "users", column: "recipient_id"
  end
end
