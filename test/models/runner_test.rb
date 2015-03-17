require 'test_helper'

class RunnerTest < ActiveSupport::TestCase
  setup do
      Race.reset
      @the_race = Race.first
      @runners = @the_race.runners
  end

  test "should run race properly" do
    assert_equal "unstarted", @the_race.state

    # Nobody knows when to start
    @runners.each do |runner|
        assert_nil runner.start_time
    end

    # Bang!
    @the_race.start!
    assert @the_race.started?
    assert_equal "running", @the_race.state

    # Now all runners predictable
    @runners.each do |runner|
        # Everyone gets a start time
        assert_not_nil runner.start_time
        
        # Tortoise defines race start, everyone else gives him a head start
        assert runner.start_time > @the_race.start_time unless runner == runners(:tortoise)

        # g10k: if all runners run expected speed, they'd all finish together
        assert_in_delta runner.start_time + runner.expected_duration.seconds, @the_race.expected_finish_time, 0.01
        # test the same thing a different way
        assert_in_delta runner.expected_checkpoint(100), @the_race.expected_finish_time, 0.01

        # Quick check that runner will be half-way round half-way into their predicted race
        assert_in_delta runner.expected_checkpoint(50), runner.start_time + 0.5 * runner.expected_duration.seconds, 0.01

        assert !runner.finished?

        # Cross the finish line
        runner.check_points << CheckPoint.new(percent: 100, check_time: @the_race.expected_finish_time)
        
        assert runner.finished?
    end

    assert_equal "finished", @the_race.state
    
  end
end
