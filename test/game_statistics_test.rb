require './test/test_helper'
require './lib/stat_tracker'
require './lib/game_statistics'

class GameStatisticsTest < Minitest::Test
  include GameStatistics

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

  def test_the_total_score
    assert_equal 10, @stat_tracker.total_score.length
  end

  def test_highest_total_score
    assert_equal 7, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 3, @stat_tracker.lowest_total_score
  end

  def test_difference_between_winner_and_loser
    expected = [1, 3, 1, 1, 2, 1, 3, 1, 2, 2]

    assert_equal expected, @stat_tracker.score_margins
  end

  def test_biggest_blowout
    assert_equal 3, @stat_tracker.biggest_blowout
  end

  def test_home_wins
    assert_equal 4, @stat_tracker.home_wins
  end

  def test_total_games
    assert_equal 10, @stat_tracker.total_games
  end

  def test_percentage_home_wins
    assert_equal 40.00, @stat_tracker.percentage_home_wins
  end

  def test_average_goals_per_game
    assert_equal 4.50, @stat_tracker.average_goals_per_game
  end

end
