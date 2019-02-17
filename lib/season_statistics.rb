module SeasonStatistics

  def find_games_by_season_id(season_id)
    @game_teams.find_all do |game|
      game.game_id.to_s[0..3] == season_id.to_s[0..3]
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

end
