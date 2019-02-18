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
    expected = {
                  3=>5,
                  6=>10,
                  27=>3,
                  16=>2,
                  12=>1,
                  15=>3,
                  28=>3,
                  1=>3,
                  30=>3,
                  19=>6,
                  22=>1,
                  23=>4,
                  7=>2,
                  5=>3,
                  26=>3,
                  14=>5
                }

    assert_equal expected, @stat_tracker.total_goals_by_team
  end

  def test_games_played_by_team
    expected = {
                  "3"=>3,
                  "6"=>3,
                  "27"=>1,
                  "16"=>1,
                  "12"=>1,
                  "15"=>1,
                  "28"=>2,
                  "1"=>2,
                  "30"=>2,
                  "19"=>2,
                  "22"=>1,
                  "23"=>1,
                  "7"=>1,
                  "5"=>1,
                  "26"=>1,
                  "14"=>1
                }

    assert_equal expected, @stat_tracker.games_played_by_team
  end

  def test_average_goals_by_team
    expected = {
                  "3"=>1.67,
                  "6"=>3.33,
                  "27"=>3.0,
                  "16"=>2.0,
                  "12"=>1.0,
                  "15"=>3.0,
                  "28"=>1.5,
                  "1"=>1.5,
                  "30"=>1.5,
                  "19"=>3.0,
                  "22"=>1.0,
                  "23"=>4.0,
                  "7"=>2.0,
                  "5"=>3.0,
                  "26"=>3.0,
                  "14"=>5.0
                }

    assert_equal expected, @stat_tracker.average_goals_by_team
  end

  def test_best_offense
    assert_equal "Lightning", @stat_tracker.best_offense
  end

  def test_worst_offense
    assert_equal "Hurricanes", @stat_tracker.worst_offense
  end

  def test_best_defense
    skip
    assert_equal "Insert_Team_Name", @stat_tracker.best_defense
  end

  def test_highest_scoring_visitor
    assert_equal "Canucks", @stat_tracker.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "Lightning", @stat_tracker.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    assert_equal "Hurricanes", @stat_tracker.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    game_path = './data/gammy_dummy_for_lowest_scoring_home_team.csv'
    team_path = './data/team_info.csv'
    game_teams_path = './data/game_teams_stats_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal "Devils", stat_tracker.lowest_scoring_home_team
  end

  def test_winningest_team
    skip
    assert_equal "Insert_Team_Name", @stat_tracker.winningest_team
  end

  def test_best_fans
    skip
    assert_equal "Insert_Team_Name", @stat_tracker.best_fans
  end

  def test_worst_fans
    skip
    assert_equal "Insert_Team_Name", @stat_tracker.worst_fans
  end

end
