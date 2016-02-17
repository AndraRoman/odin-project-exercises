# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

names = %w(Fluffy Fuzzy Kitteh Meow Muffin Boots Blackie Tigress Iris Rusty)

names.each do |name|
  cuteness, softness = Array.new(2) { rand(1..10) }
  age = rand(1..5)
  Kitten.create(name: name, age: age, cuteness: cuteness, softness: softness)
end
