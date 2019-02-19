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
    assert_equal "Rangers", @stat_tracker.most_hits("20122013")
  end

  def test_least_hits
    assert_equal "Wild", @stat_tracker.least_hits("20122013")
  end

  def test_power_play_goal_percentage
    assert_equal 0.15, @stat_tracker.power_play_goal_percentage("20122013")
  end

  def test_most_accurate_team
    assert_equal "Canucks", @stat_tracker.most_accurate_team("20122013")
  end

  def test_least_accurate_team
    assert_equal "Stars", @stat_tracker.least_accurate_team("20122013")
  end

  def test_games_grouped_by_coach_name
    games = @stat_tracker.game_teams
    coach_games = @stat_tracker.games_grouped_by_coach_name(games)

    assert_equal ["John Tortorella", "Claude Julien", "Lindy Ruff", "Paul MacLean", "Peter DeBoer", "Ted Nolan", "Patrick Roy", "Gerard Gallant", "Guy Boucher", "Bruce Boudreau", "Mike Sullivan", "Glen Gulutzan", "Michel Therrien", "Dallas Eakins", "Barry Trotz", "Dave Cameron", "Alain Vigneault", "Mike Babcock", "John Stevens", "Mike Yeo", "Dave Tippett", "Craig Berube", "Jon Cooper", "Adam Oates", "Bob Hartley", "Joe Sacco", "Joel Quenneville", "Kevin Dineen", "Bill Peters", "Peter Laviolette", "Peter Horachek"], coach_games.keys
    assert_instance_of GameTeam, coach_games["John Tortorella"].first
  end

  def test_coach_win_percentages
    games = @stat_tracker.game_teams
    coach_games = @stat_tracker.games_grouped_by_coach_name(games)
    expected = {"John Tortorella"=>0.0,
                "Claude Julien"=>1.0,
                "Lindy Ruff"=>1.0,
                "Paul MacLean"=>0.0,
                "Peter DeBoer"=>0.5,
                "Ted Nolan"=>0.0,
                "Patrick Roy"=>1.0,
                "Gerard Gallant"=>1.0,
                "Guy Boucher"=>0.5,
                "Bruce Boudreau"=>1.0,
                "Mike Sullivan"=>1.0,
                "Glen Gulutzan"=>0.0,
                "Michel Therrien"=>0.0,
                "Dallas Eakins"=>1.0,
                "Barry Trotz"=>0.0,
                "Dave Cameron"=>0.0,
                "Alain Vigneault"=>0.6666666666666666,
                "Mike Babcock"=>0.0,
                "John Stevens"=>1.0,
                "Mike Yeo"=>1.0,
                "Dave Tippett"=>0.5,
                "Craig Berube"=>0.0,
                "Jon Cooper"=>1.0,
                "Adam Oates"=>1.0,
                "Bob Hartley"=>0.0,
                "Joe Sacco"=>0.5,
                "Joel Quenneville"=>1.0,
                "Kevin Dineen"=>0.0,
                "Bill Peters"=>0.5,
                "Peter Laviolette"=>0.0,
                "Peter Horachek"=>0.0}

    assert_equal expected, @stat_tracker.coach_win_percentages(coach_games)
  end

  def test_winningest_coach
    assert_equal "Claude Julien", @stat_tracker.winningest_coach("20122013")
  end

  def test_worst_coach
    assert_equal "John Tortorella", @stat_tracker.worst_coach("20122013")
  end

  def test_biggest_bust
    assert_equal "Bruins", @stat_tracker.biggest_bust("20122013")
  end

  def test_biggest_surprise
    assert_equal "Kings", @stat_tracker.biggest_surprise("20122013")
  end

end
