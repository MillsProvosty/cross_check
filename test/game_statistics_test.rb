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
    assert_equal 53, @stat_tracker.total_score.length
  end

  def test_highest_total_score
    assert_equal 11, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_difference_between_winner_and_loser
    expected = [1, 3, 1, 1, 2, 1, 6, 1, 2, 4, 3, 1, 4, 2, 1, 2, 5, 2, 1, 1, 5, 1, 2, 2, 1, 1, 2, 1, 3, 3, 1, 2, 3, 1, 1, 1, 2, 2, 1, 2, 2, 3, 2, 1, 2, 1, 1, 1, 2, 1, 1, 2, 2]

    assert_equal expected, @stat_tracker.score_margins
  end

  def test_biggest_blowout
    assert_equal 6, @stat_tracker.biggest_blowout
  end

  def test_home_wins
    assert_equal 24, @stat_tracker.home_wins
  end

  def test_total_games
    assert_equal 53, @stat_tracker.total_games
  end

  def test_percentage_home_wins
    assert_equal 0.45, @stat_tracker.percentage_home_wins
  end

  def test_count_of_games_by_season
    expected = { "20122013"=>16,
                 "20132014"=>14,
                 "20142015"=>15,
                 "20152016"=>2,
                 "20162017"=>4,
                 "20172018"=>2 }

    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_games_and_goals_by_season
    expected = { "20122013"=>{:games=>16, :goals=>84},
                 "20132014"=>{:games=>14, :goals=>73},
                 "20142015"=>{:games=>15, :goals=>76},
                 "20152016"=>{:games=>2, :goals=>9},
                 "20162017"=>{:games=>4, :goals=>17},
                 "20172018"=>{:games=>2, :goals=>7}}

    assert_equal expected, @stat_tracker.games_and_goals_by_season
  end

  def test_average_goals_by_season
    expected = { "20122013"=>5.25,
                 "20132014"=>5.21,
                 "20142015"=>5.07,
                 "20152016"=>4.5,
                 "20162017"=>4.25,
                 "20172018"=>3.5 }

    assert_equal expected, @stat_tracker.average_goals_by_season
  end

  def test_total_score_sum
    assert_equal 266, @stat_tracker.total_score_sum
  end

  def test_average_goals_per_game
    assert_equal 5.02, @stat_tracker.average_goals_per_game
  end

  def test_visitor_wins
    assert_equal 29, @stat_tracker.visitor_wins
  end

  def test_percentage_visitor_wins
    assert_equal 0.55, @stat_tracker.percentage_visitor_wins
  end

end
