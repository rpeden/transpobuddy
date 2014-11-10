class CreateStopTimes < ActiveRecord::Migration
  def up
  	create_table :stop_times do |t|
  		t.string :stop_id
  		t.string :trip_id
  		t.time   :departure_time
  	end
  	add_index :stop_times, [:stop_id, :departure_time]
  end

  def down
  end
end
