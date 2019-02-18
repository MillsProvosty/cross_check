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
    assert_equal "Rangers", @stat_tracker.most_hits(20122013)
  end

  def test_power_play_goal_percentage
    assert_equal 0.23, @stat_tracker.power_play_goal_percentage("20122013")
  end

  def test_games_grouped_by_coach_name
    games = @stat_tracker.game_teams
    coach_games = @stat_tracker.games_grouped_by_coach_name(games)

    assert_equal ["John Tortorella", "Claude Julien"], coach_games.keys
    assert_instance_of GameTeam, coach_games["John Tortorella"].first
  end

  def test_coach_win_percentages
    skip
    assert_equal "abc", @stat_tracker.coach_win_percentages
  end

  def test_winningest_coach
    assert_equal "Claude Julien", @stat_tracker.winningest_coach("20122013")
  end

  def test_worst_coach
    assert_equal "John Tortorella", @stat_tracker.worst_coach("20122013")
  end

end
