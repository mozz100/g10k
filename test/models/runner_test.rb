require 'test_helper'

class RunnerTest < ActiveSupport::TestCase
  setup do
      Race.reset
      @the_race = Race.first
      @runners = @the_race.runners
  end

  test "should run race properly" do
    assert_equal "unstarted", @the_race.state

    # Check json representation
    json = @the_race.as_json
    assert_equal "unstarted",  json["state"]
    assert_equal Runner.count, json["runners"].length
    json["runners"].each do |runner|
      assert_equal "unstarted", runner["status"]
      assert_nil runner["expected_finish_time"]
      assert_nil runner["start_time"]
      assert_equal [], runner["check_points"]
    end

    # Nobody knows when to start
    @runners.each do |runner|
        assert_nil runner.start_time
        assert !runner.started?
    end

    # Bang!
    @the_race.start!
    assert @the_race.started?
    assert_equal "running", @the_race.state

    # Check json representation
    json = @the_race.as_json
    assert_equal "running",  json["state"]
    json["runners"].each do |runner|
      assert_equal "running", runner["status"] if runner == runners(:tortoise)
      assert_not_nil runner["expected_finish_time"]
      assert_not_nil runner["start_time"]
      assert_equal [], runner["check_points"]
    end

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

        # Check point
        runner.check_points << CheckPoint.new(percent: 90, check_time: @the_race.expected_finish_time - 10.seconds)

    end

    # Check json representation
    json = @the_race.as_json
    assert_equal "running",  json["state"]
    json["runners"].each do |runner|
      assert_equal "running", runner["status"] if runner == runners(:tortoise)
      assert_not_nil runner["expected_finish_time"]
      assert_not_nil runner["start_time"]
      assert_equal 1, runner["check_points"].length
    end

    @runners.each do |runner|
        # Cross the finish line
        runner.check_points << CheckPoint.new(percent: 100, check_time: @the_race.expected_finish_time)
        assert_in_delta 100, runner.latest_checkpoint.percent, 0.01
        assert runner.finished?
    end

    assert_equal "finished", @the_race.state

    # Check json representation
    json = @the_race.as_json
    assert_equal "finished",  json["state"]
    json["runners"].each do |runner|
      assert_equal "finished", runner["status"]
      assert_not_nil runner["expected_finish_time"]
      assert_not_nil runner["start_time"]
      assert_in_delta 0, @the_race.expected_finish_time.to_i * 1000 - runner["actual_finish_time"], 0.01
      assert_equal 2, runner["check_points"].length
    end
    
  end
end
