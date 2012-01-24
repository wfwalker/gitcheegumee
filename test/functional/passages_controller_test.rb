require 'test_helper'

class PassagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, {}, logged_in_one()
    assert_response :success
    assert_not_nil assigns(:passages)
  end

  test "should get new" do
    get :new, {}, logged_in_one()
    assert_response :success
  end

  test "should create passage" do
    assert_difference('Passage.count') do
      post :create, {:passage => { }}, logged_in_one()
    end

    assert_redirected_to passage_path(assigns(:passage))
  end

  test "should show passage" do
    get :show, {:id => passages(:one).to_param}, logged_in_one()
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:id => passages(:one).to_param}, logged_in_one()
    assert_response :success
  end

  test "should update passage" do
    put :update, {:id => passages(:one).to_param, :passage => { }}, logged_in_one()
    assert_redirected_to passage_path(assigns(:passage))
  end

  test "should destroy passage" do
    assert_difference('Passage.count', -1) do
      delete :destroy, {:id => passages(:one).to_param}, logged_in_one()
    end

    assert_redirected_to passages_path
  end
end
