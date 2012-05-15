require 'test_helper'

class SlotsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get disable" do
    get :disable
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get enable" do
    get :enable
    assert_response :success
  end

end
