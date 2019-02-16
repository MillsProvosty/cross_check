require './test/test_helper'
require './lib/stat_tracker'
require './lib/game_statistics'


class TeamTest < Minitest::Test
  def setup
    @team = Team.new(row[])

    assert_equal Team, @team
  end

#Average number of goals scored in a game across all seasons
# Season with the highest win percentage for a team.
#select each game by team_id
#group by season
#calcuate wins/total_games
#.max


  def test_game_by_teams
    expected = [2012030221, 2012030222]

  assert_equal [expected], @teams.game_by_teams(3)
  end

  # def test_best_season
  #
  #   assert_equal 20132014, @team.best_season
  # end
  #
  # def test_group_by_season
  # end
  #
  # def test_calculate_percentage
  # end
  #

end
