class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.timestamps null: false
    end
    add_index :users, :username, unique: true
  end
end
