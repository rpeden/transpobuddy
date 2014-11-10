class StopTimesController < ApplicationController
protect_from_forgery

def upcoming_buses
     
    current_time = (Time.now).strftime("%H:%M:%S")
    future_time = (Time.now + 1800).strftime("%H:%M:%S") #current time plus 30 minutes
    day_type = compute_day()
    stop_times_array = Array.new
    
    stoptimes = get_stops(day_type,params[:stop_id],current_time,future_time)
    stoptimes.each do |row|
           stop_times_array.push(:route_short_name => row.route_short_name, \
                                 :departure_time =>  row.departure_time.strftime("%H:%M:%S"), \
                                 :trip_headsign => row.trip_headsign)
    end
    
    render :text => stop_times_array.to_json
    
  end

private  

  def get_stops(day_type, stop_id, current_time, future_time)
      if (future_time_is_today?) then
          return StopTime.find_same_day(day_type,stop_id,current_time,future_time)  
      else
          return StopTime.find_across_days(day_type,stop_id,current_time,future_time)    
      end  
  end
  
  def compute_day
    if (Time.now.wday < 6)
      return "Weekday"
    elsif (Time.now.wday == 6)
      return "Saturday"
    elsif (Time.now.wday == 7)
      return "Sunday"  
    end
  end
  
  def future_time_is_today?
    ((Time.now + 1800).wday == Time.now.wday) ? true : false
  end
  
  def next_day_same_type?
    
    
  end


end