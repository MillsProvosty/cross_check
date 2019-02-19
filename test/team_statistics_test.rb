require './test/test_helper'
require './lib/stat_tracker'
require './lib/game_statistics'
require './lib/team_statistics'


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
    assert_equal "20122013", @stat_tracker.best_season("3")
    assert_equal "20142015", @stat_tracker.best_season("30")
  end

  def test_worst_season
    assert_equal "20122013", @stat_tracker.worst_season("3")
    assert_equal "20152016", @stat_tracker.worst_season("30")
  end

  def test_average_win_percentage
      # teamName: Wild avg win pct 0.5
    assert_equal 0.50, @stat_tracker.average_win_percentage("30")
  end

  def test_most_goals_scored
    assert_equal 5, @stat_tracker.most_goals_scored("6")
  end

  def test_fewest_goals_scored
    assert_equal 2, @stat_tracker.fewest_goals_scored("6")
  end

  def test_biggest_team_blowout
    assert_equal 3, @stat_tracker.biggest_team_blowout("6")
  end

  def test_worst_loss
    assert_equal 3, @stat_tracker.worst_loss("3")
  end
  
end
