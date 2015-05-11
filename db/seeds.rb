# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Race.reset
Runner.delete_all

race = Race.first

Runner.create name: "Tortoise", email: "tortoise@example.com", expected_duration: 999, race_id: race.id

Runner.create name: "Dog", email: "dog@example.com", expected_duration: 100.0, race_id: race.id

Runner.create name: "Hare", email: "hare@example.com", expected_duration: 30, race_id: race.id

race.start_time = Time.now + 20.seconds
race.save
