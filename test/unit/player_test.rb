require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  fixtures :players, :locations

  # Replace this with your real tests.
  test "relations" do
  	playerOne = players(:player_one)

  	assert_equal "MrOne", playerOne.name
  	assert_equal locations(:location_one).id, playerOne.location_id
  	assert_equal locations(:location_one), playerOne.location
  end
end
