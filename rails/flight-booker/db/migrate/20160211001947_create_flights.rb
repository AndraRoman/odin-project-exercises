class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.integer   "origin_id"
      t.integer   "destination_id"
      t.datetime  "departure_time"
      t.integer   "duration"
      t.timestamps null: false
    end
  end
end
