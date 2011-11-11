require 'test_helper'

class TasksFilterTest < Test::Unit::TestCase
 def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  def test_to_finder_options
    t = TasksFilter.new(:terms => "c++")
    assert_equal({:title => /c\+\+/i}, t.to_finder_options)
  end
end