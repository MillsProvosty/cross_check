require 'csv'
class StatTracker
  def self.from_csv(locations)
    games = add_game(locations[:games])
    teams = add_teams(locations[:teams])
    game_teams = add_game_teams(locations[:game_teams])
    StatTracker.new(games, teams, game_teams)
  end

  def add_game(game_file)
    game = []
    CSV.foreach(game_file, headers: true, header_converters:  :symbol) do |row|
      game << Game.new(row)
    end
    return games
  end

  def add_teams(team_file)
    teams = []
    CSV.foreach(team_file, headers: true, header_converters:  :symbol) do |row|
      teams << Team.new(row)
    end
    return teams
  end

  def add_game_teams(game_teams_file)
    game_teams = []
    CSV.foreach(game_team_file, headers: true, header_converters:  :symbol) do |row|
      game_team_file << GameTeam.new(row)
    end
    return games_team_file
  end
end
