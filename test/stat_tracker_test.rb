require './test/test_helper'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
    def test_stat_tracker_exists
      stat_tracker = StatTracker.new
      assert_instance_of StatTracker, stat_tracker
    end
end
