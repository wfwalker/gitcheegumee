require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  fixtures :players, :locations

  test "should get index" do
    get :index, {}, logged_in()
    assert_response :success
    assert_not_nil assigns(:players)
  end

  test "should get new" do
    get :new, {}, logged_in()
    assert_response :success
  end

  test "should create player" do
    assert_difference('Player.count') do
      post :create, {:player => { :name => 'testname', :email => 'test@email.com' }}, logged_in()
    end

    assert assigns(:player)
    # TODO assert that we get redirected to action 'play'
    assert_redirected_to(:controller => 'players', :action => 'play', :id => session[:player_id], :notice => 'Player was successfully created.')
  end

  test "should show player" do
    get :show, :id => players(:player_one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:id => players(:player_one).to_param}, logged_in()
    assert_response :success
  end

  test "should update player" do
    put :update, {:id => players(:player_one).to_param, :player => { }}, logged_in()
    assert_redirected_to player_path(assigns(:player))
  end

  test "logged in but timed out, should not update player" do
    put :update, {:id => players(:player_one).to_param, :player => { }}, logged_in_timed_out()
    assert_redirected_to(:controller => 'application', :action => 'index')
  end

  test "logged in but mismatched email, should not update player" do
    put :update, {:id => players(:player_one).to_param, :player => { }}, logged_in_wrong_email_for_player_id()
    assert_redirected_to(:controller => 'application', :action => 'index')
  end

  test "should destroy player" do
    assert_difference('Player.count', -1) do
      delete :destroy, {:id => players(:player_one).to_param}, logged_in()
    end

    assert_redirected_to players_path
  end
end
