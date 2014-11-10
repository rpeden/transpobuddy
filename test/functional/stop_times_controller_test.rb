require 'test_helper'
require 'delorean'

class StopTimesControllerTest < ActionController::TestCase

  test "should be able to fetch stop times" do
  	get(:upcoming_buses, { 'stop_id' => "6" })
  	assert_response :success
  end

  test "should fetch correct number of stop times" do
    Delorean.time_travel_to "12:00:00"
    get(:upcoming_buses, { 'stop_id' => "6" })
    Delorean.back_to_the_present
    assert_response :success
    json_response = ActiveSupport::JSON.decode @response.body 
    assert_equal 5, json_response.count
  end

  test "should fetch correct stops" do
    Delorean.time_travel_to "12:00:00"
    get(:upcoming_buses, { 'stop_id' => "6" })
    Delorean.back_to_the_present
    assert_response :success
    json_response = ActiveSupport::JSON.decode @response.body 
    first_stop = json_response[0]
    assert_equal "Downtown", first_stop["route_short_name"]
    second_stop = json_response[1]
    assert_equal "Uptown", second_stop["route_short_name"]
  end
end
