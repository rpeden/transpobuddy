class StopTime < ActiveRecord::Base
	has_one :stop
	has_one :trip
  validates :stop_id, :trip_id, :departure_time, :presence => true

	def self.find_same_day(day_type, stop_id,current_time,future_time)
    
    	self.find_by_sql ["select distinct st.departure_time, tr.trip_headsign, rt.route_short_name
                               from stop_times as st inner join trips as tr
                               on st.trip_id = tr.trip_id
                               inner join routes as rt
                               on tr.route_id = rt.route_id
                               where st.stop_id = ?
                               and (st.departure_time >= ?)
                               and (tr.service_id = ?)
                               order by st.departure_time asc
                               limit 15",
                               stop_id, current_time, day_type]
  	end

  	def self.find_across_days(day_type, stop_id,current_time,future_time)
    
    self.find_by_sql ["select distinct st.departure_time, tr.trip_headsign, rt.route_short_name
                               from stop_times as st inner join trips as tr
                               on st.trip_id = tr.trip_id
                               inner join routes as rt
                               on tr.route_id = rt.route_id
                               where st.stop_id = ?
                               and ((st.departure_time between ? and ?)
                               or (st.departure_time between '00:00:01' and ?))
                               and (tr.service_id = ?)
                               order by st.departure_time asc
                               limit 50",
                               stop_id, current_time, "11:59:59", future_time, day_type]
    
  	end
  
  	def self.find_across_day_types(current_day_type, future_day_type, stop_id, current_time, future_time)
    
    #do a query to find trips spanning days from one type to another...i.e. weekday to saturday, or saturday to sunday
    #will need current_day_type and future_day_type
    #self.find_by_sql
    
  	end
end