require 'test_helper'

class RaceTest < ActiveSupport::TestCase
  test "should reset race" do
    # Ensure there are lots of races
  	4.times do 
  		r = Race.create
  	end
  	assert Race.count >= 4

    # Call the reset method
  	Race.reset

    # There should now be one race with all runners in
  	assert Race.count == 1

    the_race = Race.first
    assert the_race.runners.count == Runner.count
    assert the_race.runners.count > 0
    assert_nil the_race.start_time
  end

  test "should get slowest runner" do
    # Set up
    Race.reset
    the_race = Race.first

    assert_equal runners(:tortoise), the_race.slowest_runner
  end

  test "starting race should make end time predictable" do
    # Set up
    Race.reset
    the_race = Race.first

    # No expected_finish_time, race hasn't started
    assert_nil the_race.expected_finish_time
    assert !the_race.started?

    # Bang!
    the_race.start!
    assert the_race.started?
    assert_not_nil the_race.expected_finish_time

    # Race now has a predicted finish time, determined by the tortoise
    assert_not_nil the_race.expected_finish_time
    assert_in_delta the_race.expected_finish_time - the_race.start_time, runners(:tortoise).expected_duration, 0.01
  end
end
