class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer "flight_id"
      t.integer "passenger_count"
      t.timestamps null: false
    end
  end
end
