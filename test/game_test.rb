require './test/test_helper'
require './lib/stat_tracker'
require './lib/game'
require 'pry'

class GameTest < Minitest::Test

  def test_add_game_adds_all_csv_rows
      games = []
      CSV.foreach("./data/game_dummy.csv", headers: true, header_converters:  :symbol) do |row|
        games << Game.new(row)
      end
      assert_equal 10, games.length
  end
end
