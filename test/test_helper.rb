ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def logged_in_one()
    return {
      :email => players(:player_one).email, 
      :player_id => players(:player_one).id, 
      :login_time => Time.now.to_i - 23
    }
  end

  def verified_email_not_logged_in()
    return {
      :email => "totally@new.email", 
    }
  end

  def logged_in_two()
    return {
      :email => players(:player_two).email, 
      :player_id => players(:player_two).id, 
      :login_time => Time.now.to_i - 23
    }
  end

  def logged_in_timed_out()
    return {
      :email => players(:player_one).email, 
      :player_id => players(:player_one).id, 
      :login_time => 1
    }
  end

  def logged_in_wrong_email_for_player_id()
    return {
      :email => 'wrongusername@user.com', 
      :player_id => players(:player_one).id, 
      :login_time => Time.now.to_i - 23
    }
  end
end

