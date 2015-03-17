require 'test_helper'

class CheckPointTest < ActiveSupport::TestCase
  setup do
    Race.reset
    @the_race = Race.first
    @runners = @the_race.runners
    @tortoise = @the_race.slowest_runner
    @hare     = @the_race.runners.find(runners(:hare).id)
  end

  test "should predict race" do
    @the_race.start!(actual_time: 500.seconds.ago)

    assert @the_race.expected_finish_time > Time.now  # tortoise 999.9

    original_tortoise_finish = @tortoise.expected_finish_time
    assert_equal @the_race.expected_finish_time, original_tortoise_finish

    # Pretend tortoise is having a blinder, hare having a shocker
    @tortoise.check_points << CheckPoint.new(check_time: @tortoise.start_time + 300.seconds, percent: 50)
    @hare.check_points     << CheckPoint.new(check_time: @hare.start_time + 300.seconds, percent: 25)

    assert_equal 2, CheckPoint.count

    assert @tortoise.expected_finish_time < original_tortoise_finish
    assert_in_delta 600.0, @tortoise.expected_finish_time - @tortoise.start_time, 0.01

    assert_in_delta 1200.0, @hare.expected_finish_time - @hare.start_time, 0.01
  end
end
