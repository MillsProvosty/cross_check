module LeagueStatistics

  def count_of_teams
    @teams.count
  end

  def total_goals_by_team
    total_goals = {}
    @games.each do |game|
      if total_goals[game.away_team_id].nil?
        total_goals[game.away_team_id] = game.away_goals
      else
        total_goals[game.away_team_id] += game.away_goals
      end
      if total_goals[game.home_team_id].nil?
        total_goals[game.home_team_id] = game.home_goals
      else
        total_goals[game.home_team_id] += game.home_goals
      end
    end
    return total_goals
  end

  def games_played_by_team
    total_games = {}
    @games.each do |game|
      if total_games[game.away_team_id].nil?
        total_games[game.away_team_id] = 1
      else
        total_games[game.away_team_id] += 1
      end
      if total_games[game.home_team_id].nil?
        total_games[game.home_team_id] = 1
      else
        total_games[game.home_team_id] += 1
      end
    end
    return total_games
  end

  def average_goals_by_team
    average_goals = {}
    total_goals = total_goals_by_team
    total_games = games_played_by_team
    total_goals.each do |team_id, goals|
      average_goals[team_id] = (goals.to_f / total_games[team_id]).round(2)
    end
    return average_goals
  end

end
