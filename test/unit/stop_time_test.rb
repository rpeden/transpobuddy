require 'test_helper'

class StopTimeTest < ActiveSupport::TestCase

	test "finds correct number of stop times" do
		stop_times = StopTime.find_same_day("Weekday", 6, "12:00", "12:05")
		assert_equal(5, stop_times.count)
	end

	test "correct trip headsign selected" do
		stop_time = StopTime.find_same_day("Weekday", 6, "12:00", "12:05").first
		assert_equal("Vaughan Mills", stop_time.trip_headsign)
	end

	test "should not save without stop id" do
		stop_time = StopTime.new
		stop_time.trip_id = "123"
		stop_time.departure_time = "12:00:00"
		assert !stop_time.save, "saved stop time with no stop id"
	end

	test "should not save without trip id" do
		stop_time = StopTime.new
		stop_time.stop_id = "123"
		stop_time.departure_time = "12:00:00"
		assert !stop_time.save, "saved stop time with no trip id"	
	end

	test "should not save without a departure time" do
		stop_time = StopTime.new
		stop_time.trip_id = "123"
		stop_time.stop_id = "abc"
		assert !stop_time.save, "saved stop time with no departure time"
	end

end
