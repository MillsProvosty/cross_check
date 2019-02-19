module LeagueStatistics

  def count_of_teams
    @teams.count
  end

  def team_id_to_name_converter(team_id)
    team_object =  @teams.find do |team|
      team.team_id == team_id
    end

    team_object.teamname
  end

  def team_info(team_id)
    team_object = teams.find { |team| team.team_id == team_id }
    {
      "team_id" => team_object.team_id,
      "franchise_id" => team_object.franchiseid,
      "short_name" => team_object.shortname,
      "team_name" => team_object.teamname,
      "abbreviation" => team_object.abbreviation,
      "link" => team_object.link
    }
  end

  def favorite_opponent(team_id)
    opponent_win_percentages = find_opponent_win_percentages(team_id)

    opponent_win_percentages.min_by do |opponent_team_name, win_percent|
      win_percent
    end.first
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

  def total_goals_allowed_by_team
    total_goals = {}
    @games.each do |game|
      if total_goals[game.away_team_id].nil?
        total_goals[game.away_team_id] = game.home_goals
      else
        total_goals[game.away_team_id] += game.home_goals
      end
      if total_goals[game.home_team_id].nil?
        total_goals[game.home_team_id] = game.away_goals
      else
        total_goals[game.home_team_id] += game.away_goals
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

    # # 5) Convert team_id to teamname
    team_id_to_name_converter(highest_scoring_team_id)
  end

  def highest_scoring_home_team
    home_games_by_team_id = @games.group_by do |game|
      game.home_team_id
    end

    # 1) Build hash with home team id as key, value = total games played.
    home_team_id_with_games_played = {}
    home_games_by_team_id.each do |team_id, games|
      home_team_id_with_games_played[team_id] = games.length
    end

    # 2) Build hash with home team id as key, value = total home goals scored
    home_team_id_with_goals_scored = {}
    home_games_by_team_id.each do |team_id, games|
      home_goals = games.sum do |game|
        game.home_goals
      end

      home_team_id_with_goals_scored[team_id] = home_goals
    end

    # 3) Build hash home team id as key, value = average goals scored
    home_team_id_with_average_goals_scored = {}
    home_games_by_team_id.each do |team_id, games|
      average_goals_scored = home_team_id_with_goals_scored[team_id] / home_team_id_with_games_played[team_id].to_f

      home_team_id_with_average_goals_scored[team_id] = average_goals_scored
    end

    # 4) Take 3rd hash and call .max on the average goals scored (values)
    highest_scoring_team_id  = home_team_id_with_average_goals_scored.max_by do |team_id, average_goals|
      average_goals
    end.first

    # # 5) Convert team_id to teamname
    team_id_to_name_converter(highest_scoring_team_id)
  end

  def best_offense
    best_offense_team_id = average_goals_by_team.max_by do |team_id, average_goals|
      average_goals
    end.first

    team_id_to_name_converter(best_offense_team_id)
  end

  def worst_offense
    worst_offense_team_id = average_goals_by_team.min_by do |team_id, average_goals|
      average_goals
    end.first

    team_id_to_name_converter(worst_offense_team_id)
  end

  def average_goals_allowed_by_team
    average_goals = {}
    total_goals = total_goals_allowed_by_team
    total_games = games_played_by_team
    total_goals.each do |team_id, goals|
      average_goals[team_id] = (goals.to_f / total_games[team_id]).round(2)
    end
    return average_goals
  end

  def best_defense
    best_defense_team_id = average_goals_allowed_by_team.min_by do |team_id, average_goals|
      average_goals
    end.first

    team_id_to_name_converter(best_defense_team_id)
  end

  def worst_defense
    worst_defense_team_id = average_goals_allowed_by_team.max_by do |team_id, average_goals|
      average_goals
    end.first

    team_id_to_name_converter(worst_defense_team_id)
  end

  def lowest_scoring_visitor
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

    # 4) Take 3rd hash and call .min on the average goals scored (values)
    lowest_scoring_team_id  = visitor_team_id_with_average_goals_scored.min_by do |team_id, average_goals|
      average_goals
    end.first

    # # 5) Convert team_id to teamname
    team_id_to_name_converter(lowest_scoring_team_id)
  end

  def lowest_scoring_home_team
    home_games_by_team_id = @games.group_by do |game|
      game.home_team_id
    end

    # 1) Build hash with home team id as key, value = total games played.
    home_team_id_with_games_played = {}
    home_games_by_team_id.each do |team_id, games|
      home_team_id_with_games_played[team_id] = games.length
    end

    # 2) Build hash with home team id as key, value = total home goals scored
    home_team_id_with_goals_scored = {}
    home_games_by_team_id.each do |team_id, games|
      home_goals = games.sum do |game|
        game.home_goals
      end

      home_team_id_with_goals_scored[team_id] = home_goals
    end

    # 3) Build hash home team id as key, value = average goals scored
    home_team_id_with_average_goals_scored = {}
    home_games_by_team_id.each do |team_id, games|
      average_goals_scored = home_team_id_with_goals_scored[team_id] / home_team_id_with_games_played[team_id].to_f

      home_team_id_with_average_goals_scored[team_id] = average_goals_scored
    end

    # 4) Take 3rd hash and call .min on the average goals scored (values)
    lowest_scoring_team_id  = home_team_id_with_average_goals_scored.min_by do |team_id, average_goals|
      average_goals
    end.first

    # # 5) Convert team_id to teamname
    team_id_to_name_converter(lowest_scoring_team_id)
  end

  def best_fans
    # Create hash with key = team_id, value = games_played at home
    home_games_played = {}
    @games.each do |game|
      if home_games_played[game.home_team_id].nil?
        home_games_played[game.home_team_id] = 1
      else
        home_games_played[game.home_team_id] += 1
      end
    end

    # Create hash with key = team_id, value = wins at home
    home_games_wins = {}
    @games.each do |game|
      if game.outcome.include?("home win")
        if home_games_wins[game.home_team_id].nil?
          home_games_wins[game.home_team_id] = 1
        else
          home_games_wins[game.home_team_id] += 1
        end
      end
    end

    # Create hash with key = team_id, value = home_win_percentage
    home_win_percentage = {}
    home_games_played.each do |team_id, games_played|
      wins = home_games_wins[team_id]
      wins = 0 if wins.nil?

      if !games_played.nil?
        home_win_percentage[team_id] = (wins / games_played.to_f).round(2)
      end
    end

    # Create hash with key = team_id, value = games_played at away
    away_games_played = {}
    @games.each do |game|
      if away_games_played[game.away_team_id].nil?
        away_games_played[game.away_team_id] = 1
      else
        away_games_played[game.away_team_id] += 1
      end
    end

    # Create hash with key = team_id, value = away wins
    away_games_wins = {}
    @games.each do |game|
      if game.outcome.include?("away win")
        if away_games_wins[game.away_team_id].nil?
          away_games_wins[game.away_team_id] = 1
        else
          away_games_wins[game.away_team_id] += 1
        end
      end
    end

    # Create hash with key = team_id, value = away_win_percentage
    away_win_percentage = {}
    away_games_played.each do |team_id, games_played|
      wins = away_games_wins[team_id]
      wins = 0 if wins.nil?

      if !games_played.nil?
        away_win_percentage[team_id] = (wins / games_played.to_f).round(2)
      end
    end

    # Create hash with key = team_id, value = (home - away_win_percentages)
    win_percentage_difference = {}
    home_win_percentage.each do |team_id, home_win_percent|
      away_win_percent = away_win_percentage[team_id]

      if !home_win_percent.nil? && !away_win_percent.nil?
        win_percentage_difference[team_id] = home_win_percent - away_win_percent
      end
    end

    # Find max win_percentage_difference
    best_fans_team_id = win_percentage_difference.max_by do |team_id, win_percent_difference|
      win_percent_difference
    end.first

    team_id_to_name_converter(best_fans_team_id)
  end

  def worst_fans
    # List of names of all teams with better away records than home records.
    # Create hash with key = team_id, value = games_played at home
    home_games_played = {}
    @games.each do |game|
      if home_games_played[game.home_team_id].nil?
        home_games_played[game.home_team_id] = 1
      else
        home_games_played[game.home_team_id] += 1
      end
    end

    # Create hash with key = team_id, value = wins at home
    home_games_wins = {}
    @games.each do |game|
      if game.outcome.include?("home win")
        if home_games_wins[game.home_team_id].nil?
          home_games_wins[game.home_team_id] = 1
        else
          home_games_wins[game.home_team_id] += 1
        end
      end
    end

    # Create hash with key = team_id, value = home_win_percentage
    home_win_percentage = {}
    home_games_played.each do |team_id, games_played|
      wins = home_games_wins[team_id]
      wins = 0 if wins.nil?

      if !games_played.nil?
        home_win_percentage[team_id] = (wins / games_played.to_f).round(2)
      end
    end

    # Create hash with key = team_id, value = games_played at away
    away_games_played = {}
    @games.each do |game|
      if away_games_played[game.away_team_id].nil?
        away_games_played[game.away_team_id] = 1
      else
        away_games_played[game.away_team_id] += 1
      end
    end

    # Create hash with key = team_id, value = away wins
    away_games_wins = {}
    @games.each do |game|
      if game.outcome.include?("away win")
        if away_games_wins[game.away_team_id].nil?
          away_games_wins[game.away_team_id] = 1
        else
          away_games_wins[game.away_team_id] += 1
        end
      end
    end

    # Create hash with key = team_id, value = away_win_percentage
    away_win_percentage = {}
    away_games_played.each do |team_id, games_played|
      wins = away_games_wins[team_id]
      wins = 0 if wins.nil?

      if !games_played.nil?
        away_win_percentage[team_id] = (wins / games_played.to_f).round(2)
      end
    end

    # Create hash with key = team_id, value = (home - away_win_percentages)
    worst_fans_array = []
    win_percentage_difference = {}
    home_win_percentage.each do |team_id, home_win_percent|
      away_win_percent = away_win_percentage[team_id]

      if !home_win_percent.nil? && !away_win_percent.nil?
        win_percentage_difference[team_id] = home_win_percent - away_win_percent
      end

      if !win_percentage_difference[team_id].nil? && win_percentage_difference[team_id] < 0
          worst_fans_array << team_id
      end
    end

    worst_fans_array.map { |team_id| team_id_to_name_converter(team_id) }
  end

  def winningest_team
    total_wins_by_team_id = {}
    count_of_games = games_played_by_team
    win_percentage_by_team_id = {}

    total_games_by_team_id = games.group_by do |game|
      game.home_team_id  || game.away_team_id
    end

    total_games_by_team_id.each do |team_id, games|
      total_wins_by_team_id[team_id] = 0

      games.each do |game|
        if game.home_team_id == team_id && game.outcome.include?("home win")
          total_wins_by_team_id[team_id] += 1

        elsif game.away_team_id == team_id &&
          game.outcome.include?("away win")
          total_wins_by_team_id[season_id] += 1
        end
      end

      wins = total_wins_by_team_id[team_id]
      games_played = count_of_games[team_id]
      win_percentage_by_team_id[team_id] = (wins / games_played.to_f).round(2)
    end

    winningest_team_id = win_percentage_by_team_id.max_by do |team_id, win_percentage|
      win_percentage
    end.first

    team_id_to_name_converter(winningest_team_id)
  end
end
