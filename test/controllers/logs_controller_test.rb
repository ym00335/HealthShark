require 'test_helper'

class LogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @log = logs(:one)
  end

  test "should get index" do
    get logs_url
    assert_response :success
  end

  test "should get new" do
    get new_log_url
    assert_response :success
  end

  test "should create log" do
    assert_difference('Log.count') do
      post logs_url, params: { log: { calories: @log.calories, end_time: @log.end_time, meal: @log.meal, meal_name: @log.meal_name, rating: @log.rating, start_time: @log.start_time } }
    end

    assert_redirected_to log_url(Log.last)
  end

  test "should show log" do
    get log_url(@log)
    assert_response :success
  end

  test "should get edit" do
    get edit_log_url(@log)
    assert_response :success
  end

  test "should update log" do
    patch log_url(@log), params: { log: { calories: @log.calories, end_time: @log.end_time, meal: @log.meal, meal_name: @log.meal_name, rating: @log.rating, start_time: @log.start_time } }
    assert_redirected_to log_url(@log)
  end

  test "should destroy log" do
    assert_difference('Log.count', -1) do
      delete log_url(@log)
    end

    assert_redirected_to logs_url
  end
end