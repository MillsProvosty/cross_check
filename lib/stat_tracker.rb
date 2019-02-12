require 'csv'
class StatTracker

  def self.from_csv(locations)
    @games = []
    @teams = locations[:teams]
    @game_teams = locations[:game_teams]
  end

  def add_game(game_file)
    CSV.foreach(game_file, headers: true, header_converters:  :symbol) do |row|
      @game << Game.new(row)
    end
  end
end
