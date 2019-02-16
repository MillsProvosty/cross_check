module TeamStatistics

  def best_season(team_id)
    #select each game by team_id
    games_by_team_id = @games.find_all do |game|
      game.away_team_id == team_id || game.home_team_id == team_id
    end

    #group by season
    games_by_season = games_by_team_id.group_by do |game|
      game.season
    end

    #calcuate wins/total_games
    total_wins_by_season = {}
    total_games_by_season = {}

    games_by_season.each do |season_id, games|
      total_games_by_season[season_id] = games.length
      total_wins_by_season[season_id] = 0

      games.each do |game|
        if game.home_team_id == team_id && game.outcome.include?("home win")
          total_wins_by_season[season_id] += 1

        elsif game.away_team_id == team_id &&
          game.outcome.include?("away win")
          total_wins_by_season[season_id] += 1
        end
      end
    end

    #calcuate wins/total_games
    win_percentage_by_season = {}
    total_wins_by_season.each do |season_id, total_wins|
      win_percentage_by_season[season_id] = total_wins / total_games_by_season[season_id].to_f
    end

    #.max
    return win_percentage_by_season.max_by do |season_id, win_percentage|
      win_percentage
    end.first
  end
end
