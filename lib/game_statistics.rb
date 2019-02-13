module GameStatistics

  def total_score
    @games.map do |game|
      game.away_goals + game.home_goals
    end
  end

  def highest_total_score
    total_score.max
  end

  def lowest_total_score
    total_score.min
  end

  def score_margins
    @games.map do |game|
      (game.away_goals - game.home_goals).abs
    end
  end

  def biggest_blowout
    score_margins.max
  end

  def home_wins
    home_wins = 0
    @games.each do |game|
      if game.outcome.include?("home win")
        home_wins += 1
      end
    end
    return home_wins
  end

  def total_games
    @games.length
  end

  def percentage_home_wins
    (home_wins / total_games.to_f).round(2) * 100
  end

  def average_goals_by_season
    season_hash = games_and_goals_by_season
    result = {}
    season_hash.each do |season, values|
      result[season] = (values[:goals] / values[:games].to_f).round(2)
    end
    result
  end

  def games_and_goals_by_season
    season_hash = {}
    @games.each do |game|
      season = game.season
      game_goals = game.away_goals + game.home_goals
      if season_hash[season].nil?
        season_hash[season] =
          { games: 1,
            goals: game_goals
          }
      else
        season_hash[season][:games] += 1
        season_hash[season][:goals] += game_goals
      end
    end
    season_hash
  end
  
  def average_goals_per_game
    (total_score_sum / total_games.to_f).round(2)
  end

  def total_score_sum
    total_score.sum
  end
  
  def visitor_wins
    visitor_wins = 0
    @games.each do |game|
      if game.outcome.include?("away win")
        visitor_wins += 1
      end
    end
    return visitor_wins
  end

  def percentage_visitor_wins
    (visitor_wins / total_games.to_f).round(2) * 100
  end
end
