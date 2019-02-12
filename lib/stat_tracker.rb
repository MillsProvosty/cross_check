require 'csv'
require './lib/game'
require './lib/game_team'
require './lib/team'
require './lib/game_statistics'

class StatTracker
  include GameStatistics

  attr_reader :games,
              :teams,
              :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def self.from_csv(file_locations)
    games = create_game_objects(file_locations[:games])
    teams = create_teams_objects(file_locations[:teams])
    game_teams = create_game_teams_objects(file_locations[:game_teams])
    StatTracker.new(games, teams, game_teams)
  end

  def self.create_game_objects(file_location)
    games = []
    CSV.foreach(file_location, headers: true, header_converters:  :symbol) do |row|
      games << Game.new(row)
    end
    return games
  end

  def self.create_teams_objects(team_file)
    teams = []
    CSV.foreach(team_file, headers: true, header_converters:  :symbol) do |row|
      teams << Team.new(row)
    end
    return teams
  end

  def self.create_game_teams_objects(game_teams_file)
    game_teams = []
    CSV.foreach(game_teams_file, headers: true, header_converters:  :symbol) do |row|
      game_teams << GameTeam.new(row)
    end
    return game_teams
  end
end
