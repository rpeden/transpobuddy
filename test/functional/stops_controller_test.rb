require 'test_helper'


class StopsControllerTest < ActionController::TestCase

  test "should be able to fetch stops" do
  	get(:fetch_stops, { 'lngMin' => 1.0, 'lngMax' => 5.0, 'latMin' => 1.0, 'latMax' => 5.0})
  	assert_response :success
  end

  test "fetches correct stop" do
  	get(:fetch_stops, { 'lngMin' => 1.0, 'lngMax' => 1.0, 'latMin' => 1.0, 'latMax' => 1.0})
  	assert_response :success  
  	json_response = ActiveSupport::JSON.decode @response.body 
  	assert_equal "stop1", json_response[0]['stop_name']
  	assert_equal "1", json_response[0]['stop_id']
  end

  test "fetches correct number of stops" do
    get(:fetch_stops, { 'lngMin' => 1.0, 'lngMax' => 10.0, 'latMin' => 1.0, 'latMax' => 10.0}) 
    assert_response :success  
    json_response = ActiveSupport::JSON.decode @response.body 
    assert_equal 10, json_response.count
  end

end
