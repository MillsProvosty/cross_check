module SeasonStatistics

  def most_hits(season_id)
  # 1) Find all games with the season id
    all_games_with_season_id = @game_teams.find_all do |game|
      game.game_id.to_s[0..3] == season_id.to_s[0..3]
    end

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

end
