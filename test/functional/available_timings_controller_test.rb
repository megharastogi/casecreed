require 'test_helper'

class AvailableTimingsControllerTest < ActionController::TestCase
  setup do
    @available_timing = available_timings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:available_timings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create available_timing" do
    assert_difference('AvailableTiming.count') do
      post :create, :available_timing => @available_timing.attributes
    end

    assert_redirected_to available_timing_path(assigns(:available_timing))
  end

  test "should show available_timing" do
    get :show, :id => @available_timing.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @available_timing.to_param
    assert_response :success
  end

  test "should update available_timing" do
    put :update, :id => @available_timing.to_param, :available_timing => @available_timing.attributes
    assert_redirected_to available_timing_path(assigns(:available_timing))
  end

  test "should destroy available_timing" do
    assert_difference('AvailableTiming.count', -1) do
      delete :destroy, :id => @available_timing.to_param
    end

    assert_redirected_to available_timings_path
  end
end
