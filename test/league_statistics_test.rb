require './test/test_helper'
require './lib/stat_tracker'
require './lib/league_statistics'

class LeagueStatisticsTest < Minitest::Test
  include LeagueStatistics

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

  def test_count_of_teams
    assert_equal 33, @stat_tracker.count_of_teams
  end

  def test_total_goals_by_team
    expected = {1 => 1,
                3 => 5,
                5 => 3,
                6 => 10,
                7 => 2,
                12 => 1,
                15 => 3,
                16 => 2,
                19 => 4,
                22 => 1,
                23 => 4,
                27 => 3,
                28 => 3,
                30 => 3}

    assert_equal expected, @stat_tracker.total_goals_by_team
  end

  def test_games_played_by_team
    expected = {1 => 1,
                3 => 3,
                5 => 1,
                6 => 3,
                7 => 1,
                12 => 1,
                15 => 1,
                16 => 1,
                19 => 1,
                22 => 1,
                23 => 1,
                27 => 1,
                28 => 2,
                30 => 2}
    assert_equal expected, @stat_tracker.games_played_by_team
  end

  def test_average_goals_by_team
    expected = {1 => 1.0,
                3 => 1.67,
                5 => 3.0,
                6 => 3.33,
                7 => 2.0,
                12 => 1.0,
                15 => 3.0,
                16 => 2.0,
                19 => 4.0,
                22 => 1.0,
                23 => 4.0,
                27 => 3.0,
                28 => 1.5,
                30 => 1.5}
    assert_equal expected, @stat_tracker.average_goals_by_team
  end

  def test_best_offense
    # Note this is team_id 19, avg_goals = 4.0.
    # Currently the dummy data has a tie for max, team_id 23 (Canucks) are also 4.0
    assert_equal "Blues", @stat_tracker.best_offense
  end

  def test_worst_offense
    # Again, there is a tie for lowest average goals for dummy data at 1.0
    assert_equal "Devils", @stat_tracker.worst_offense
  end

  def test_best_defense
    assert_equal "Insert_Team_Name", @stat_tracker.best_defense
  end

  def test_highest_scoring_visitor
    assert_equal "Insert_Team_Name", @stat_tracker.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "Insert_Team_Name", @stat_tracker.highest_scoring_home_team
  end

end
