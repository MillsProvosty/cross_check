require './test/test_helper'
require './lib/stat_tracker'
require './lib/season_statistics'


class SeasonStatisticsTest < Minitest::Test
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

  def test_most_hits
    assert_equal "Bruins", @stat_tracker.most_hits(20122013)
    assert_equal "Oilers", @stat_tracker.most_hits(20142015)
  end

end
