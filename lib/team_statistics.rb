module TeamStatistics


  def win_percentage_by_season(team_id)
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
    win_percentage_by_season_hash = {}
    total_wins_by_season.each do |season_id, total_wins|
      win_percentage_by_season_hash[season_id] = total_wins / total_games_by_season[season_id].to_f
    end
    win_percentage_by_season_hash
  end

  def best_season(team_id)
    win_percentage_by_season(team_id).max_by do |season_id, win_percentage|
      win_percentage
    end.first
  end

  def worst_season(team_id)
    win_percentage_by_season(team_id).min_by do |season_id, win_percentage|
      win_percentage
    end.first
  end

  def average_win_percentage(team_id)
    #select each game by team_id
    games_by_team_id = @games.find_all do |game|
      game.away_team_id == team_id || game.home_team_id == team_id
    end

    #calcuate wins/total_games
    total_games_by_team_id = games_by_team_id.length
    total_wins_by_team_id = 0

    games_by_team_id.each do |game|
        if game.home_team_id == team_id && game.outcome.include?("home win")
          total_wins_by_team_id += 1

        elsif game.away_team_id == team_id &&
          game.outcome.include?("away win")
          total_wins_by_team_id += 1
        end
      end

    #calcuate wins/total_games
    (total_wins_by_team_id / total_games_by_team_id.to_f).round(2)

  end

  def most_goals_scored(team_id)
    games_by_away_team_id = @games.find_all do |game|
      game.away_team_id == team_id
    end

    games_by_home_team_id = @games.find_all do |game|
        game.home_team_id == team_id
    end

    max_away_goal = games_by_away_team_id.max_by do |game|
      game.away_goals
    end
    max_away_goal = max_away_goal.away_goals

    max_home_goal = games_by_home_team_id.max_by do |game|
      game.home_goals
    end
      max_home_goal = max_home_goal.home_goals

      if max_home_goal > max_away_goal
        return max_home_goal
      else
        return max_away_goal
      end
  end

  def fewest_goals_scored(team_id)
    games_by_away_team_id = @games.find_all do |game|
      game.away_team_id == team_id
    end

    games_by_home_team_id = @games.find_all do |game|
        game.home_team_id == team_id
    end

    min_away_goal = games_by_away_team_id.min_by do |game|
      game.away_goals
    end
    min_away_goal = min_away_goal.away_goals

    min_home_goal = games_by_home_team_id.min_by do |game|
      game.home_goals
    end
      min_home_goal = min_home_goal.home_goals

      if min_home_goal < min_away_goal
        return min_home_goal
      else
        return min_away_goal
      end

  end

  def max_score_difference(games)
    score_diff_max = 1
    games.each do |game|
        score_diff = (game.away_goals - game.home_goals).abs
        if score_diff > score_diff_max
          score_diff_max = score_diff
        end
    end
    score_diff_max
  end

  def biggest_team_blowout(team_id)
    # Select all games that team_id won
    games_team_won = @games.find_all do |game|
      team_id == game.away_team_id && game.outcome.include?("away win") ||
        team_id == game.home_team_id && game.outcome.include?("home win")
    end
    # For each game, calculate score difference and assign max
    max_score_difference(games_team_won)
  end

  def worst_loss(team_id)
    # Select all games that team_id lost
    games_team_lost = @games.find_all do |game|
      team_id == game.away_team_id && game.outcome.include?("home win") ||
        team_id == game.home_team_id && game.outcome.include?("away win")
    end
    # For each game, calculate score difference and assign max
    max_score_difference(games_team_lost)
  end

end
