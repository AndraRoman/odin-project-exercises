class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer "event_id", null: false
      t.integer "invitee_id", null: false
      t.timestamps null: false
    end
  end
end
