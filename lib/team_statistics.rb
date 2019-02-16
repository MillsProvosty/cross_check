module TeamStatistics

  def best_season(team_id)
    #select each game by team_id
    games_grouped_by_id = @games.group_by do |game|
      game.away_team_id || game.home_team_id
    end
    


    #group by season
    #calcuate wins/total_games
    #.max

  end

end
