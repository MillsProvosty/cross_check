class Team
  attr_reader :team_id
              :franchiseid
              :shortname
              :teamname
              :abbreviation
              :link

  def initialize(row)
    @team_id = row[:team_id].to_i
    @franchiseid = row[:franchiseid].to_i
    @shortname = row[:shortname]
    @teamname = row[:teamname]
    @abbreviation = row[:abbreviation]
    @link = row[:link]
  end

end
