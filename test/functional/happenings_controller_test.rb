require 'test_helper'

class HappeningsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, {}, logged_in_one()
    assert_response :success
    assert_not_nil assigns(:happenings)
  end

  test "should get new" do
    get :new, {}, logged_in_one()
    assert_response :success
  end

  test "should create happening" do
    assert_difference('Happening.count') do
      post :create, {:happening => { }}, logged_in_one()
    end

    assert_redirected_to happening_path(assigns(:happening))
  end

  test "should show happening" do
    get :show, :id => happenings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:id => happenings(:one).to_param}, logged_in_one()
    assert_response :success
  end

  test "should update happening" do
    put :update, {:id => happenings(:one).to_param, :happening => { }}, logged_in_one()
    assert_redirected_to happening_path(assigns(:happening))
  end

  test "should destroy happening" do
    assert_difference('Happening.count', -1) do
      delete :destroy, {:id => happenings(:one).to_param}, logged_in_one()
    end

    assert_redirected_to happenings_path
  end
end
