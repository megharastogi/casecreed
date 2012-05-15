require 'test_helper'

class VoteForNextCitiesControllerTest < ActionController::TestCase
  setup do
    @vote_for_next_city = vote_for_next_cities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vote_for_next_cities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vote_for_next_city" do
    assert_difference('VoteForNextCity.count') do
      post :create, :vote_for_next_city => @vote_for_next_city.attributes
    end

    assert_redirected_to vote_for_next_city_path(assigns(:vote_for_next_city))
  end

  test "should show vote_for_next_city" do
    get :show, :id => @vote_for_next_city.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @vote_for_next_city.to_param
    assert_response :success
  end

  test "should update vote_for_next_city" do
    put :update, :id => @vote_for_next_city.to_param, :vote_for_next_city => @vote_for_next_city.attributes
    assert_redirected_to vote_for_next_city_path(assigns(:vote_for_next_city))
  end

  test "should destroy vote_for_next_city" do
    assert_difference('VoteForNextCity.count', -1) do
      delete :destroy, :id => @vote_for_next_city.to_param
    end

    assert_redirected_to vote_for_next_cities_path
  end
end
