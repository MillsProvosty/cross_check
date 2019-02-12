require './test/test_helper'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test

  def setup
    file_location = './data/game_dummy.csv'
    @games = StatTracker.create_game_objects(file_location)
  end

  def test_game_attributes
    assert_equal 2, @games.first.away_goals
    assert_equal 3, @games.first.away_team_id
    assert_equal "2013-05-16", @games.first.date_time
    assert_equal 2012030221, @games.first.game_id
    assert_equal 3, @games.first.home_goals
    assert_equal "left", @games.first.home_rink_side_start
    assert_equal 6, @games.first.home_team_id
    assert_equal "home win OT", @games.first.outcome
    assert_equal 20122013, @games.first.season
    assert_equal "P", @games.first.type
  end
end
