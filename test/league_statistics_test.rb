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

  def test_team_info
    expected = {
      "team_id" => "18",
      "franchise_id" => "34",
      "short_name" => "Nashville",
      "team_name" => "Predators",
      "abbreviation" => "NSH",
      "link" => "/api/v1/teams/18"
    }

    assert_equal expected, @stat_tracker.team_info("18")
  end

  def test_count_of_teams
    assert_equal 33, @stat_tracker.count_of_teams
  end

  def test_total_goals_by_team
    expected = {
                  "3"=>16,
                  "6"=>16,
                  "8"=>12,
                  "1"=>8,
                  "19"=>23,
                  "10"=>14,
                  "14"=>5,
                  "22"=>0,
                  "29"=>6,
                  "26"=>15,
                  "12"=>9,
                  "27"=>4,
                  "23"=>20,
                  "21"=>8,
                  "52"=>16,
                  "28"=>15,
                  "4"=>2,
                  "7"=>5,
                  "5"=>8,
                  "17"=>11,
                  "13"=>6,
                  "24"=>11,
                  "18"=>13,
                  "16"=>0,
                  "25"=>4,
                  "9"=>4,
                  "30"=>5,
                  "20"=>4,
                  "2"=>2,
                  "15"=>4
                }

    assert_equal expected, @stat_tracker.total_goals_by_team
  end

  def test_total_goals_allowed_by_team
    expected = {
                "3"=>17,
                "6"=>11,
                "8"=>8,
                "1"=>9,
                "19"=>15,
                "10"=>17,
                "14"=>5,
                "22"=>8,
                "29"=>9,
                "26"=>6,
                "12"=>6,
                "27"=>9,
                "23"=>11,
                "21"=>8,
                "52"=>25,
                "28"=>14,
                "4"=>3,
                "7"=>12,
                "5"=>4,
                "17"=>16,
                "13"=>8,
                "24"=>8,
                "18"=>11,
                "16"=>2,
                "25"=>6,
                "9"=>2,
                "30"=>7,
                "20"=>3,
                "2"=>4,
                "15"=>2
              }
    assert_equal expected, @stat_tracker.total_goals_allowed_by_team
  end

  def test_games_played_by_team
    expected = {
                  "3"=>6,
                  "6"=>5,
                  "8"=>5,
                  "1"=>4,
                  "19"=>6,
                  "10"=>5,
                  "14"=>2,
                  "22"=>2,
                  "29"=>3,
                  "26"=>4,
                  "12"=>4,
                  "27"=>2,
                  "23"=>5,
                  "21"=>3,
                  "52"=>8,
                  "28"=>6,
                  "4"=>1,
                  "7"=>4,
                  "5"=>3,
                  "17"=>6,
                  "13"=>3,
                  "24"=>3,
                  "18"=>5,
                  "16"=>1,
                  "25"=>3,
                  "9"=>2,
                  "30"=>2,
                  "20"=>1,
                  "2"=>1,
                  "15"=>1
                }

    assert_equal expected, @stat_tracker.games_played_by_team
  end

  def test_average_goals_by_team
    expected = {
                  "3"=>2.67,
                  "6"=>3.2,
                  "8"=>2.4,
                  "1"=>2.0,
                  "19"=>3.83,
                  "10"=>2.8,
                  "14"=>2.5,
                  "22"=>0.0,
                  "29"=>2.0,
                  "26"=>3.75,
                  "12"=>2.25,
                  "27"=>2.0,
                  "23"=>4.0,
                  "21"=>2.67,
                  "52"=>2.0,
                  "28"=>2.5,
                  "4"=>2.0,
                  "7"=>1.25,
                  "5"=>2.67,
                  "17"=>1.83,
                  "13"=>2.0,
                  "24"=>3.67,
                  "18"=>2.6,
                  "16"=>0.0,
                  "25"=>1.33,
                  "9"=>2.0,
                  "30"=>2.5,
                  "20"=>4.0,
                  "2"=>2.0,
                  "15"=>4.0
                }

    assert_equal expected, @stat_tracker.average_goals_by_team
  end

  def test_best_offense
    assert_equal "Canucks", @stat_tracker.best_offense
  end

  def test_worst_offense
    assert_equal "Oilers", @stat_tracker.worst_offense
  end

  def test_average_goals_allowed_by_team
    expected = {
                "3"=>3.33,
                "6"=>1.67,
                "27"=>2.0,
                "16"=>3.0,
                "12"=>3.0,
                "15"=>1.0,
                "28"=>2.0,
                "1"=>3.5,
                "30"=>2.5,
                "19"=>2.0,
                "22"=>2.0,
                "23"=>2.0,
                "7"=>4.0,
                "5"=>1.0,
                "26"=>2.0,
                "14"=>2.0
              }
    assert_equal expected, @stat_tracker.average_goals_allowed_by_team
  end

  def test_best_defense
    assert_equal "Senators", @stat_tracker.best_defense
  end

  def test_worst_defense
    assert_equal "Coyotes", @stat_tracker.worst_defense
  end

  def test_highest_scoring_visitor
    assert_equal "Blues", @stat_tracker.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "Canucks", @stat_tracker.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    assert_equal "Coyotes", @stat_tracker.lowest_scoring_visitor
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

  def test_best_fans
    assert_equal "Hurricanes", @stat_tracker.best_fans
  end

  def test_worst_fans
    assert_equal ["Lightning", "Red Wings", "Panthers", "Sabres", "Canadiens", "Predators", "Sharks"], @stat_tracker.worst_fans
  end

  def test_winningest_team
    assert_equal "Kings", @stat_tracker.winningest_team
  end

end
