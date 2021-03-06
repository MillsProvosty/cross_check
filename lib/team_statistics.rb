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

  def favorite_opponent(team_id)
    opponent_win_percentages = find_opponent_win_percentages(team_id)

    opponent_win_percentages.min_by do |opponent_team_name, win_percent|
      win_percent
    end.first
  end

  def rival(team_id)
    opponent_win_percentages = find_opponent_win_percentages(team_id)

    opponent_win_percentages.max_by do |opponent_team_name, win_percent|
      win_percent
    end.first
  end

  def seasonal_summary(team_id)
    # Find all games by team_id
    games_by_team_id = @games.find_all do |game|
      game.away_team_id == team_id || game.home_team_id == team_id
    end

    # games Group_by season_id
    games_grouped_by_season = games_by_team_id.group_by do |game|
      game.season
    end

    # Group by pre-season / regular season
    games_grouped_by_season_and_type = {}
    games_grouped_by_season.each do |season_id, games|
      games_grouped_by_season_and_type[season_id] = {}
      if games_grouped_by_season_and_type[season_id][:preseason].nil?
        games_grouped_by_season_and_type[season_id][:preseason] = {
          wins: 0,
          total_games: 0,
          total_goals_scored: 0,
          total_goals_against: 0 }
      end
      if games_grouped_by_season_and_type[season_id][:regular_season].nil?
        games_grouped_by_season_and_type[season_id][:regular_season] = {
          wins: 0,
          total_games: 0,
          total_goals_scored: 0,
          total_goals_against: 0 }
      end

      games.each do |game|
        if team_id == game.away_team_id
          win = 1 if game.outcome.include?("away win")
          win = 0 if game.outcome.include?("home win")
          goals_scored = game.away_goals
          goals_against = game.home_goals
        else
          win = 1 if game.outcome.include?("home win")
          win = 0 if game.outcome.include?("away win")
          goals_scored = game.home_goals
          goals_against = game.away_goals
        end

        season_type = :preseason if game.type == "P"
        season_type = :regular_season if game.type == "R"

        games_grouped_by_season_and_type[season_id][season_type][:wins] += win
        games_grouped_by_season_and_type[season_id][season_type][:total_games] += 1
        games_grouped_by_season_and_type[season_id][season_type][:total_goals_scored] += goals_scored
        games_grouped_by_season_and_type[season_id][season_type][:total_goals_against] += goals_against
      end

    end

    # Build expected hash from data above
    result = {}
    games_grouped_by_season_and_type.each do |season_id, season_type_hash|
      result[season_id] = {}

      season_type_hash.each do |season_type, stats|
        result[season_id][season_type] = {}

        if stats[:total_games] > 0
          result[season_id][season_type][:win_percentage] = (stats[:wins] / stats[:total_games].to_f).round(2)
          result[season_id][season_type][:average_goals_scored] = (stats[:total_goals_scored] / stats[:total_games].to_f).round(2)
          result[season_id][season_type][:average_goals_against] = (stats[:total_goals_against] / stats[:total_games].to_f).round(2)
        else
          result[season_id][season_type][:win_percentage] = 0
          result[season_id][season_type][:average_goals_scored] = 0
          result[season_id][season_type][:average_goals_against] = 0
        end

        result[season_id][season_type][:total_goals_scored] = stats[:total_goals_scored]
        result[season_id][season_type][:total_goals_against] = stats[:total_goals_against]
      end
    end
    result
  end

  def find_opponent_win_percentages(team_id)
    # Find all games by team_id
    games_by_team_id = @games.find_all do |game|
      game.away_team_id == team_id || game.home_team_id == team_id
    end
    
    # Create hash with key = opponent, value = wins by opponent
    opponent_wins = {}

    games_by_team_id.each do |game|
      if team_id == game.away_team_id && game.outcome.include?("home win")
        opponent_team_name = team_id_to_name_converter(game.home_team_id)

        if opponent_wins[opponent_team_name].nil?
          opponent_wins[opponent_team_name] = 1
        else
          opponent_wins[opponent_team_name] += 1
        end

      elsif team_id == game.home_team_id && game.outcome.include?("away win")
        opponent_team_name = team_id_to_name_converter(game.away_team_id)

        if opponent_wins[opponent_team_name].nil?
          opponent_wins[opponent_team_name] = 1
        else
          opponent_wins[opponent_team_name] += 1
        end

      end
    end

    # Create hash with key = opponent, value = total games against opponent
    opponent_games_played_together = {}
    games_by_team_id.each do |game|
      if team_id == game.away_team_id
        opponent_team_name = team_id_to_name_converter(game.home_team_id)

        if opponent_games_played_together[opponent_team_name].nil?
          opponent_games_played_together[opponent_team_name] = 1
        else
          opponent_games_played_together[opponent_team_name] += 1
        end

      else
        opponent_team_name = team_id_to_name_converter(game.away_team_id)

        if opponent_games_played_together[opponent_team_name].nil?
          opponent_games_played_together[opponent_team_name] = 1
        else
          opponent_games_played_together[opponent_team_name] += 1
        end
      end
    end

    # Use the above to calculate opponent win percentages against team_id
    opponent_win_percentages = {}
    opponent_games_played_together.each do |opponent_team_name, games_played|
      if opponent_wins[opponent_team_name].nil?
        opponent_win_percentages[opponent_team_name] = 0
      else
        win_percent = (opponent_wins[opponent_team_name] / games_played.to_f)
        opponent_win_percentages[opponent_team_name] = win_percent
      end
    end
    opponent_win_percentages
  end

  def head_to_head(team_id)
    # Find all games by team_id
    games_by_team_id = @games.find_all do |game|
      game.away_team_id == team_id || game.home_team_id == team_id
    end

    # Create hash with key = opponent, value = wins by opponent
    opponent_wins = {}

    games_by_team_id.each do |game|
      if team_id == game.away_team_id && game.outcome.include?("home win")
        opponent_team_id = game.home_team_id

        if opponent_wins[opponent_team_id].nil?
          opponent_wins[opponent_team_id] = 1
        else
          opponent_wins[opponent_team_id] += 1
        end

      elsif team_id == game.home_team_id && game.outcome.include?("away win")
        opponent_team_id = game.away_team_id

        if opponent_wins[opponent_team_id].nil?
          opponent_wins[opponent_team_id] = 1
        else
          opponent_wins[opponent_team_id] += 1
        end

      end
    end

    # Create hash with key = opponent, value = total games against opponent
    opponent_games_played_together = {}
    games_by_team_id.each do |game|
      if team_id == game.away_team_id
        opponent_team_id = game.home_team_id

        if opponent_games_played_together[opponent_team_id].nil?
          opponent_games_played_together[opponent_team_id] = 1
        else
          opponent_games_played_together[opponent_team_id] += 1
        end

      else
        opponent_team_id = game.away_team_id

        if opponent_games_played_together[opponent_team_id].nil?
          opponent_games_played_together[opponent_team_id] = 1
        else
          opponent_games_played_together[opponent_team_id] += 1
        end
      end
    end

    # Use the above to calculate opponent win percentages against team_id
    opponent_win_percentages = {}
    opponent_games_played_together.each do |opponent_team_id, games_played|
      opponent_team_name = team_id_to_name_converter(opponent_team_id)
      if opponent_wins[opponent_team_id].nil?
        opponent_win_percentages[opponent_team_name] = 1.0
      else
        win_percent = (1.00 - opponent_wins[opponent_team_id] / games_played.to_f).round(2)
        opponent_win_percentages[opponent_team_name] = win_percent
      end
    end

    opponent_win_percentages
  end

end
