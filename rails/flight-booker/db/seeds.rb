# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["SFO", "LAX", "JFK"].each do |code|
  Airport.create!(code: code)
end

20.times do
  code = (Array.new(3) { rand(65..90).chr }).join('')
  Airport.create(code: code) # could be invalid
end

2000.times do
  origin, destination = Airport.limit(2).order("RANDOM()")
  departure_time = rand(2.months).seconds.from_now
  duration = rand(100..5000)
  flight = Flight.create!(origin_id: origin.id, destination_id: destination.id, departure_time: departure_time, duration: duration)
end
