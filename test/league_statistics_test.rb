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

  def test_total_number_of_goals_by_team
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

  # Step 1: Create hash
  # Step 2: Each game has Away Goals & Home Goals
  # Step 3:

end
