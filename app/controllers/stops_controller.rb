class StopsController < ApplicationController
protect_from_forgery

def fetch_stops
	#arel syntax
   @stops = Stop.select("stop_id, stop_name, stop_lat, stop_lon").where("(stop_lat between ? and ?) and (stop_lon between ? and ?)", \
             params[:latMin], params[:latMax], params[:lngMin], params[:lngMax]).limit(30)
   # @jsonstops = Array.new

   # @stops.each do |row|

   #   @jsonstops.push(:stop_lat => row.stop_lat, :stop_lon => row.stop_lon, :stop_name => row.stop_name, :stop_id => row.stop_id)

   # end
   render :text => @stops.to_json
end

end