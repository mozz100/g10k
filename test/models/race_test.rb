require 'test_helper'

class RaceTest < ActiveSupport::TestCase
  test "should reset race" do
  	4.times do 
  		r = Race.create
  	end
  	assert Race.count >= 4
  	Race.reset
  	assert Race.count == 1
    the_race = Race.first
    assert the_race.runners.count == Runner.count
    assert the_race.runners.count > 0
  end
end
