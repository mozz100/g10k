require 'test_helper'

class RaceTest < ActiveSupport::TestCase
  test "should reset race" do
  	4.times do 
  		r = Race.create
  	end
  	assert Race.count >= 4
  	Race.reset
  	assert Race.count == 1
  end
end
