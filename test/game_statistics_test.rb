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
    expected = [1, 3, 1, 1, 2, 1, 3, 1, 2, 2, 1, 3]

    assert_equal expected, @stat_tracker.score_margins
  end

  def test_biggest_blowout
    assert_equal 3, @stat_tracker.biggest_blowout
  end

  def test_home_wins
    assert_equal 5, @stat_tracker.home_wins
  end

  def test_total_games
    assert_equal 12, @stat_tracker.total_games
  end

  def test_percentage_home_wins
    assert_equal 40.00, @stat_tracker.percentage_home_wins
  end

  def test_count_of_games_by_season
    expected = {
                20122013=>6,
                20152016=>3,
                20142015=>1,
                20172018=>2
              }

    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_games_and_goals_by_season
    expected = { 20122013 => { :games=>5,
                               :goals=>24 },
                 20152016 => { :games=>3,
                               :goals=>12 },
                 20142015 => { :games=>1,
                               :goals=>3 },
                 20172018 => { :games=>1,
                               :goals=>6 } }

    assert_equal expected, @stat_tracker.games_and_goals_by_season
  end

  def test_average_goals_by_season
    expected = { 20122013 => 4.8,
                 20142015 => 3.0,
                 20152016 => 4.0,
                 20172018 => 6.0 }

    assert_equal expected, @stat_tracker.average_goals_by_season
  end

  def test_total_score_sum
    assert_equal 57, @stat_tracker.total_score_sum
  end

  def test_average_goals_per_game
    assert_equal 4.50, @stat_tracker.average_goals_per_game
  end

  def test_visitor_wins
    assert_equal 7, @stat_tracker.visitor_wins
  end

  def test_percentage_visitor_wins
    assert_equal 60.00, @stat_tracker.percentage_visitor_wins
  end

end
