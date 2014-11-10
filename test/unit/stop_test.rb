require 'test_helper'

class StopTest < ActiveSupport::TestCase

	test "correct stop gets selected" do
		test_stop = Stop.where("stop_id = ?", 6).first
		assert_equal("stop6", test_stop.stop_name)
		assert_equal(6.0, test_stop.stop_lat)
		assert_equal(6.0, test_stop.stop_lon)
	end

	test "should not save without a stop id" do
		stop = Stop.new
		stop.stop_name = "something"
		stop.stop_lon = 1.0
		stop.stop_lat = 1.0
		assert !stop.save, "saved stop with no id"
	end

	test "should not save without a stop name" do
		stop = Stop.new
		stop.stop_id = "abc"
		stop.stop_lat = 1.0
		stop.stop_lon = 1.0
		assert !stop.save, "saved stop with no name"
	end

	test "should not save a stop with no latitude" do
		stop = Stop.new
		stop.stop_id = "abc"
		stop.stop_name = "something"
		stop.stop_lon = 1.0
		assert !stop.save, "saved a stop with no latitude"
	end

	test "should not save a stop with no longitude do" do
		stop = Stop.new
		stop.stop_id = "abc"
		stop.stop_name = "something"
		stop.stop_lat = 1.0
		assert !stop.save, "saved a stop with no longitude"
	end

	test "should not save stop with non-numeric latitude" do
		stop = Stop.new
		stop.stop_id = "abc"
		stop.stop_name = "something"
		stop.stop_lat = "abcdefg"
		stop.stop_lon = 1.0
		assert !stop.save, "saved a stop with a non-numeric latitude"
	end

	test "should not save a stop with a non-numeric longitude" do
		stop = Stop.new
		stop.stop_id = "abc"
		stop.stop_name = "something"
		stop.stop_lon = "abcdefg"
		stop.stop_lat = 1.0
		assert !stop.save, "saved a stop with a non-numeric latitude"
	end

end
