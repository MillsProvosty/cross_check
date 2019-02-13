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

  def average_goals_per_game
    (total_score.sum / total_games.to_f).round(2)
  end

end
