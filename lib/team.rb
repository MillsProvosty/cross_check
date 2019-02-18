class Team
  attr_reader :team_id,
              :franchiseid,
              :shortname,
              :teamname,
              :abbreviation,
              :link

  def initialize(row)
    @team_id = row[:team_id]
    @franchiseid = row[:franchiseid]
    @shortname = row[:shortname]
    @teamname = row[:teamname]
    @abbreviation = row[:abbreviation]
    @link = row[:link]

  end

  # def game_by_teams(team_id)
  #   game_array = []
  #   @games.each do |game|
  #     game_array << @games.team_id
  #   end
  # end

  # def count_wins_by_team_id
  #   win_count = game_array.each do |game|
  #     game.wins
  #   if @stat_tracker.wins == true
  #     hash += 1
  #   end
  # end
  # end



end
