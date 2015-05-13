require 'test_helper'

class RunnersControllerTest < ActionController::TestCase
  setup do
    @runner = runners(:tortoise)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:runners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create runner" do
    assert_difference('Runner.count') do
      post :create, runner: { email: @runner.email, expected_duration: @runner.expected_duration, name: @runner.name }
    end

    assert_redirected_to runner_path(assigns(:runner))
  end

  test "should show runner" do
    get :show, id: @runner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @runner
    assert_response :success
  end

  test "should update runner" do
    patch :update, id: @runner, runner: { email: @runner.email, expected_duration: @runner.expected_duration, name: @runner.name }
    assert_redirected_to runner_path(assigns(:runner)), assigns(:runner).errors.inspect
  end

  test "should destroy runner" do
    assert_difference('Runner.count', -1) do
      delete :destroy, id: @runner
    end

    assert_redirected_to runners_path
  end

  test "should create checkpoint" do
    now = Time.now
    ct = now.getutc.to_i
    assert_difference('CheckPoint.count', +1) do
      post :checkpoint, id: @runner, percent: 50, check_time: ct
    end
    assert_response :success
    assert_equal now.getutc.to_s, @runner.latest_checkpoint.check_time.getutc.to_s
    assert_equal 50,  @runner.latest_checkpoint.percent
  end

  test "should reset race" do
    initial_id = races(:g10k).id
    post :reset
    assert_not_equal initial_id, Race.first.id
    assert_response :success
  end

  test "should start race" do
    Race.reset
    assert !Race.first.started?
    gun = Time.now
    post :start_race, start_time: gun.to_i
    assert_response :success
    assert Race.first.started?
    assert_equal gun.getutc.to_s, Race.first.start_time.getutc.to_s
  end


end
