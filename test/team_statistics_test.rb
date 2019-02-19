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
    assert_equal "20132014", @stat_tracker.best_season("3")
    assert_equal "20132014", @stat_tracker.best_season("30")
  end

  def test_worst_season
    assert_equal "20122013", @stat_tracker.worst_season("3")
    assert_equal "20132014", @stat_tracker.worst_season("30")
  end

  def test_average_win_percentage
    assert_equal 0.67, @stat_tracker.average_win_percentage("5")
    assert_equal 0.5, @stat_tracker.average_win_percentage("1")
  end

  def test_most_goals_scored
    assert_equal 5, @stat_tracker.most_goals_scored("6")
  end

  def test_fewest_goals_scored
    assert_equal 2, @stat_tracker.fewest_goals_scored("6")
  end

  def test_head_to_head
    expected = { "Flyers"=>1.0,
                 "Red Wings"=>1.0,
                 "Rangers"=>0.0,
                 "Predators"=>1.0,
                 "Sabres"=>0.0 }

    assert_equal expected, @stat_tracker.head_to_head("28")
  end

  def test_head_to_head_for_another_team
    expected = { "Canadiens"=>1.0,
                 "Jets"=>0.0,
                 "Ducks"=>0.0,
                 "Stars"=>1.0}

    assert_equal expected, @stat_tracker.head_to_head("1")
  end

  def test_head_to_head_for_a_third_team
    expected = {"Bruins"=>0.0, "Canucks"=>1.0, "Jets"=>0.0, "Sharks"=>1.0}

    assert_equal expected, @stat_tracker.head_to_head("3")
  end

  def test_seasonal_summary
    expected = {"20122013"=>{:preseason=>{:win_percentage=>0.0, :average_goals_scored=>1.67, :average_goals_against=>3.33, :total_goals_scored=>5, :total_goals_against=>10}, :regular_season=>{:win_percentage=>0.0, :average_goals_scored=>3.0, :average_goals_against=>4.0, :total_goals_scored=>3, :total_goals_against=>4}}, "20132014"=>{:preseason=>{:win_percentage=>0, :average_goals_scored=>0, :average_goals_against=>0, :total_goals_scored=>0, :total_goals_against=>0}, :regular_season=>{:win_percentage=>1.0, :average_goals_scored=>5.0, :average_goals_against=>2.0, :total_goals_scored=>5, :total_goals_against=>2}}, "20142015"=>{:preseason=>{:win_percentage=>0, :average_goals_scored=>0, :average_goals_against=>0, :total_goals_scored=>0, :total_goals_against=>0}, :regular_season=>{:win_percentage=>1.0, :average_goals_scored=>3.0, :average_goals_against=>1.0, :total_goals_scored=>3, :total_goals_against=>1}}}

    assert_equal expected, @stat_tracker.seasonal_summary("3")
  end

  def test_biggest_team_blowout
    assert_equal 3, @stat_tracker.biggest_team_blowout("6")
  end

  def test_worst_loss
    assert_equal 3, @stat_tracker.worst_loss("3")

  end

  def test_favorite_opponent
    assert_equal "Red Wings", @stat_tracker.favorite_opponent("30")
    assert_equal "Canadiens", @stat_tracker.favorite_opponent("1")
  end

  def test_rival
    assert_equal "Hurricanes", @stat_tracker.rival("2")
    assert_equal "Bruins", @stat_tracker.rival("3")
  end

end
