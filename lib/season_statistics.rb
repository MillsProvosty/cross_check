module SeasonStatistics

  def find_games_by_season_id(season_id)
    @game_teams.find_all do |game|
      game.game_id.to_s[0..3] == season_id[0..3]
    end
  end

  def most_hits(season_id)
  # 1) Find all games with the season id
    all_games_with_season_id = find_games_by_season_id(season_id)

  # 2) Create hash, key = team_id and value = number_of_hits
    team_id_with_number_of_hits = {}
    all_games_with_season_id.each do |game|
      if team_id_with_number_of_hits[game.team_id].nil?
        team_id_with_number_of_hits[game.team_id] = game.hits

      else
        team_id_with_number_of_hits[game.team_id] += game.hits
      end
    end

  # 3) Find the max
    max_team_id = team_id_with_number_of_hits.max_by do |team_id, hits|
      hits
    end.first

    # 4) Convert team_id to teamname
    team_object =  @teams.find do |team|
      team.team_id == max_team_id
    end

    team_object.teamname
  end

  def least_hits(season_id)
    # 1) Find all games with the season id
      all_games_with_season_id = find_games_by_season_id(season_id)

    # 2) Create hash, key = team_id and value = number_of_hits
      team_id_with_number_of_hits = {}
      all_games_with_season_id.each do |game|
        if team_id_with_number_of_hits[game.team_id].nil?
          team_id_with_number_of_hits[game.team_id] = game.hits

        else
          team_id_with_number_of_hits[game.team_id] += game.hits
        end
      end

    # 3) Find the max
      min_team_id = team_id_with_number_of_hits.min_by do |team_id, hits|
        hits
      end.first

      # 4) Convert team_id to teamname
      team_object =  @teams.find do |team|
        team.team_id == min_team_id
      end

      team_object.teamname
  end

  def power_play_goal_percentage(season_id)
    # 1) Find all games with the season id
    all_games_with_season_id = find_games_by_season_id(season_id)

    # 2) Find count of total goals in season id
    total_goals = all_games_with_season_id.sum do |game|
      game.goals
    end

    # 3) Find count of power play goals in season id
    power_play_goals = all_games_with_season_id.sum do |game|
      game.powerplaygoals
    end

    # 4) Calculate percentage, = (Step 2) / (Step 3)
    (power_play_goals.to_f / total_goals).round(2)
  end

  def most_accurate_team(season_id)
    all_games_with_season_id = find_games_by_season_id(season_id)

    # Create hash with key = team_id, value = games by team_id
    games_grouped_by_team_id = all_games_with_season_id.group_by do |game|
      game.team_id
    end

    # Create hash with key = team_id, value = ratio (goals / shots)
    ratio_goals_per_shots = {}
    games_grouped_by_team_id.each do |team_id, games|
      goals = games.sum { |game| game.goals }
      shots = games.sum { |game| game.shots }

      ratio_goals_per_shots[team_id] = goals.to_f / shots
    end

    # Find team_id with max ratio
    most_accurate_team_id = ratio_goals_per_shots.max_by do |team_id, goals_per_shots|
      goals_per_shots
    end.first

    # Convert team_id to team_name
    team_object =  @teams.find do |team|
      team.team_id == most_accurate_team_id
    end

    team_object.teamname
  end

  def least_accurate_team(season_id)
    all_games_with_season_id = find_games_by_season_id(season_id)

    # Create hash with key = team_id, value = games by team_id
    games_grouped_by_team_id = all_games_with_season_id.group_by do |game|
      game.team_id
    end

    # Create hash with key = team_id, value = ratio (goals / shots)
    ratio_goals_per_shots = {}
    games_grouped_by_team_id.each do |team_id, games|
      goals = games.sum { |game| game.goals }
      shots = games.sum { |game| game.shots }
      ratio_goals_per_shots[team_id] = goals.to_f / shots
    end

    # Find team_id with minimum ratio
    most_accurate_team_id = ratio_goals_per_shots.min_by do |team_id, goals_per_shots|
      goals_per_shots
    end.first

    # Convert team_id to team_name
    team_object =  @teams.find do |team|
      team.team_id == most_accurate_team_id
    end

    team_object.teamname
  end

  def games_grouped_by_coach_name(games)
    # Creates hash with key = coach name, value is array of games by coach
    games.group_by do |game|
      game.head_coach
    end
  end

  def coach_win_percentages(coach_games)
    # Create hash with key = coach name, value is win_percentage
    win_percentages = {}
    coach_games.each do |coach, games|
      total_games_played = games.length
      wins = games.count { |game| game.won }
      win_percentages[coach] = wins / total_games_played.to_f
    end
    win_percentages
  end

  def winningest_coach(season_id)
    # Find all games with the season id
    all_games_with_season_id = find_games_by_season_id(season_id)

    # Create hash with key = coach name, value is array of games by coach
    coach_games = games_grouped_by_coach_name(all_games_with_season_id)

    # Create hash with key = coach name, value is win_percentage
    win_percentages = coach_win_percentages(coach_games)

    # Find key/value pair with max win percentage
    win_percentages.max_by do |coach, win_percentage|
      win_percentage
    end.first
  end

  def worst_coach(season_id)
    # Find all games with the season id
    all_games_with_season_id = find_games_by_season_id(season_id)

    # Create hash with key = coach name, value is array of games by coach
    coach_games = games_grouped_by_coach_name(all_games_with_season_id)

    # Create hash with key = coach name, value is win_percentage
    win_percentages = coach_win_percentages(coach_games)

    # Find key/value pair with max win percentage
    win_percentages.min_by do |coach, win_percentage|
      win_percentage
    end.first
  end

  def biggest_bust(season_id)
    # Find all games from season_id
    all_games_from_season_id = games.find_all do |game|
      season_id == game.season
    end

    # Create hash with key = team_id, value = hash with values
    #  :preseason_wins, :preseason_total_games, :regular_wins, :regular_total_games
    team_records = {}
    all_games_from_season_id.each do |game|
      away_team_id = game.away_team_id
      home_team_id = game.home_team_id

      if team_records[away_team_id].nil?
        team_records[away_team_id] = {
          preseason_wins: 0,
          preseason_total_games: 0,
          regular_wins: 0,
          regular_total_games: 0
        }
      end

      if team_records[home_team_id].nil?
        team_records[home_team_id] = {
          preseason_wins: 0,
          preseason_total_games: 0,
          regular_wins: 0,
          regular_total_games: 0
        }
      end

      if game.type == "P"
        team_records[away_team_id][:preseason_total_games] += 1
        team_records[home_team_id][:preseason_total_games] += 1

        if game.outcome.include?("away win")
          team_records[away_team_id][:preseason_wins] += 1
        else
          team_records[home_team_id][:preseason_wins] += 1
        end

      else
        team_records[away_team_id][:regular_total_games] += 1
        team_records[home_team_id][:regular_total_games] += 1

        if game.outcome.include?("away win")
          team_records[away_team_id][:regular_wins] += 1
        else
          team_records[home_team_id][:regular_wins] += 1
        end
      end

    end

    # Create hash with key = team_id, value = pre-win% - reg-win%
    win_percentages = {}
    team_records.each do |team_id, team_stats|
      if team_stats[:preseason_total_games] == 0
        preseason_win_percentage = 0
      else
        preseason_win_percentage = team_stats[:preseason_wins] / team_stats[:preseason_total_games].to_f
      end

      if team_stats[:regular_total_games] == 0
        regular_win_percentage = 0
      else
        regular_win_percentage = team_stats[:regular_wins] / team_stats[:regular_total_games].to_f
      end

      win_percentages[team_id] = (preseason_win_percentage - regular_win_percentage).round(2)
    end

    # Find .max on above
    team_id_biggest_bust = win_percentages.max_by do |team_id, win_percent|
      win_percent
    end.first

    # Convert to team name
    teams.find { |team| team.team_id == team_id_biggest_bust }.teamname
  end

end
