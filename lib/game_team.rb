class GameTeam
  attr_reader :game_id,
              :team_id,
              :HoA,
              :won,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :hits,
              :pim,
              :powerPlayOpportunities,
              :powerPlayGoals,
              :faceOffWinPercentage,
              :giveaways,
              :takeaways

  def initialize(row)
    @game_id = row[:game_id].to_i
    @team_id = row[:team_id].to_i
    @HoA = row[:HoA]
    @won = string_to_boolean(row[:won]) # Converts string to boolean
    @settled_in = row[:settled_in]
    @head_coach = row[:head_coach]
    @goals = row[:goals].to_i
    @shots = row[:shots].to_i
    @hits = row[:hits].to_i
    @pim = row[:pim].to_i
    @powerPlayOpportunities = row[:powerPlayOpportunities].to_i
    @powerPlayGoals = row[:powerPlayGoals].to_i
    @faceOffWinPercentage = row[:faceOffWinPercentage].to_f
    @giveaways = row[:giveaways].to_i
    @takeaways = row[:takeaways].to_i
  end

  def string_to_boolean(string)
    string == "TRUE"
  end

end
