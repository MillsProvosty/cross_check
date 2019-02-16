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
    expected = 20122013

    assert_equal expected, @stat_tracker.best_season(3)
  end
end
