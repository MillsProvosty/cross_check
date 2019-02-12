class GameTeam
  attr_reader :game_id,
              :team_id,
              :hoa,
              :won,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :hits,
              :pim,
              :powerplayopportunities,
              :powerplaygoals,
              :faceoffwinpercentage,
              :giveaways,
              :takeaways

  def initialize(row)
    @game_id = row[:game_id].to_i
    @team_id = row[:team_id].to_i
    @hoa = row[:hoa]
    @won = string_to_boolean(row[:won]) # Converts string to boolean
    @settled_in = row[:settled_in]
    @head_coach = row[:head_coach]
    @goals = row[:goals].to_i
    @shots = row[:shots].to_i
    @hits = row[:hits].to_i
    @pim = row[:pim].to_i
    @powerplayopportunities = row[:powerplayopportunities].to_i
    @powerplaygoals = row[:powerplaygoals].to_i
    @faceoffwinpercentage = row[:faceoffwinpercentage].to_f
    @giveaways = row[:giveaways].to_i
    @takeaways = row[:takeaways].to_i
  end

  def string_to_boolean(string)
    string == "TRUE"
  end

end
