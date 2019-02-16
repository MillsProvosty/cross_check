require './test/test_helper'
require './lib/stat_tracker'
require './lib/game_statistics'


class TeamTest < Minitest::Test
  def setup
    game_path = './data/game_dummy.csv'
    team_path = './data/team_info.csv'
    game_teams_path = './data/game_teams_stats_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_best_season
    assert_equal 20122013, @stat_tracker.best_season(3)
    assert_equal 20142015, @stat_tracker.best_season(30)
  end

  def test_worst_season
    skip
    assert_equal 20122013, @stat_tracker.worst_season(3)
    assert_equal 20152016, @stat_tracker.worst_season(30)
  end
end
