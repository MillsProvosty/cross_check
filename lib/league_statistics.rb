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

end
