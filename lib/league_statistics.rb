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

  def highest_scoring_visitor
    visitor_games_by_team_id = @games.group_by do |game|
      game.away_team_id
    end

    # 1) Build hash with visitor team id as key, value = total games played.
    visitor_team_id_with_games_played = {}
    visitor_games_by_team_id.each do |team_id, games|
      visitor_team_id_with_games_played[team_id] = games.length
    end

    # 2) Build hash with visitor team id as key, value = total visitor goals scored
    visitor_team_id_with_goals_scored = {}
    visitor_games_by_team_id.each do |team_id, games|
      visitor_away_goals = games.sum do |game|
        game.away_goals
      end

      visitor_team_id_with_goals_scored[team_id] = visitor_away_goals
    end

    # 3) Build hash visitor team id as key, value = average goals scored
    visitor_team_id_with_average_goals_scored = {}
    visitor_games_by_team_id.each do |team_id, games|
      average_goals_scored = visitor_team_id_with_goals_scored[team_id] / visitor_team_id_with_games_played[team_id].to_f

      visitor_team_id_with_average_goals_scored[team_id] = average_goals_scored
    end

    # 4) Take 3rd hash and call .max on the average goals scored (values)
    highest_scoring_team_id  = visitor_team_id_with_average_goals_scored.max_by do |team_id, average_goals|
      average_goals
    end.first

    # 5) Convert team_id to teamname
    team_object =  @teams.find do |team|
      team.team_id == highest_scoring_team_id
    end

    return team_object.teamname
  end

end
