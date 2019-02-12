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

end
