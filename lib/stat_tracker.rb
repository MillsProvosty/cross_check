require 'csv'
class StatTracker
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

  def create_game_objects(file_location)
    games = []
    CSV.foreach(file_location, headers: true, header_converters:  :symbol) do |row|
      games << Game.new(row)
    end
    return games
  end

  def create_teams_objects(team_file)
    teams = []
    CSV.foreach(team_file, headers: true, header_converters:  :symbol) do |row|
      teams << Team.new(row)
    end
    return teams
  end

  def create_game_teams_objects(game_teams_file)
    game_teams = []
    CSV.foreach(game_team_file, headers: true, header_converters:  :symbol) do |row|
      game_teams << GameTeam.new(row)
    end
    return games_teams
  end
end
