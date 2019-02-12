require './test/test_helper'
require './lib/stat_tracker'
require 'pry'

class StatTrackerTest < Minitest::Test

  def setup
    game_file_location = './data/game_dummy.csv'
    @games = StatTracker.create_game_objects(game_file_location)

    game_teams_file_location = './data/game_teams_stats_dummy.csv'
    @game_teams = StatTracker.create_game_teams_objects(game_teams_file_location)

    team_info_file_location = './data/team_info.csv'
    @teams = StatTracker.create_teams_objects(team_info_file_location)
  end

  def test_game_attributes
    assert_equal 2, @games.first.away_goals
    assert_equal 3, @games.first.away_team_id
    assert_equal "2013-05-16", @games.first.date_time
    assert_equal 2012030221, @games.first.game_id
    assert_equal 3, @games.first.home_goals
    assert_equal "left", @games.first.home_rink_side_start
    assert_equal 6, @games.first.home_team_id
    assert_equal "home win OT", @games.first.outcome
    assert_equal 20122013, @games.first.season
    assert_equal "P", @games.first.type
  end

  def test_game_team_attributes
    assert_equal 44.8, @game_teams.first.faceoffwinpercentage
    assert_equal 2012030221, @game_teams.first.game_id
    assert_equal 17, @game_teams.first.giveaways
    assert_equal 2, @game_teams.first.goals
    assert_equal "John Tortorella", @game_teams.first.head_coach
    assert_equal 44, @game_teams.first.hits
    assert_equal "away", @game_teams.first.hoa
    assert_equal 8, @game_teams.first.pim
    assert_equal 0, @game_teams.first.powerplaygoals
    assert_equal 3, @game_teams.first.powerplayopportunities
    assert_equal "OT", @game_teams.first.settled_in
    assert_equal 35, @game_teams.first.shots
    assert_equal 7, @game_teams.first.takeaways
    assert_equal 3, @game_teams.first.team_id
    assert_equal false, @game_teams.first.won
  end

  def test_team_attributes
    assert_equal "NJD", @teams.first.abbreviation
    assert_equal 23, @teams.first.franchiseid
    assert_equal "/api/v1/teams/1", @teams.first.link
    assert_equal "New Jersey", @teams.first.shortname
    assert_equal 1, @teams.first.team_id
    assert_equal "Devils", @teams.first.teamname
  end

  def test_from_csv_works
    game_path = './data/game_dummy.csv'
    team_path = './data/team_info.csv'
    game_teams_path = './data/game_teams_stats_dummy.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)

    assert_equal 10, stat_tracker.games.length
    assert_equal 10, stat_tracker.game_teams.length
    assert_equal 33, stat_tracker.teams.length
  end
end
