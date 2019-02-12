module GameStatistics

  def total_score
    games.map do |game|
      game.away_goals + game.home_goals
    end
  end

  def gs_highest_total_score(games)
    total_score.max
  end
end
