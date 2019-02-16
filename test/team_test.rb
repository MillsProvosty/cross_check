require './test/test_helper'
require './lib/stat_tracker'
require './lib/game_statistics'


class TeamTest < Minitest::Test
  def setup
    @team = Team.new

    assert_equal Team, @team
  end

  def test_best_season
    #select each game by team_id
    #group by season
    #calcuate wins/total_games
    #.max

    assert_equal
  end

  def test_get_team_id  
  end

  def test_group_by_season
  end

  def test_calculate_percentage
  end


end
