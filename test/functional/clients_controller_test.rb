require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get block" do
    get :block
    assert_response :success
  end

  test "should get unblock" do
    get :unblock
    assert_response :success
  end

end
