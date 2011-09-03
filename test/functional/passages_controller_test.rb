require 'test_helper'

class PassagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:passages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create passage" do
    assert_difference('Passage.count') do
      post :create, :passage => { }
    end

    assert_redirected_to passage_path(assigns(:passage))
  end

  test "should show passage" do
    get :show, :id => passages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => passages(:one).to_param
    assert_response :success
  end

  test "should update passage" do
    put :update, :id => passages(:one).to_param, :passage => { }
    assert_redirected_to passage_path(assigns(:passage))
  end

  test "should destroy passage" do
    assert_difference('Passage.count', -1) do
      delete :destroy, :id => passages(:one).to_param
    end

    assert_redirected_to passages_path
  end
end
