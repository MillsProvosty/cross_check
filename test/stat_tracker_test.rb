require './test/test_helper'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
    def test_add_game

      assert_equal [], @games
    end
end
