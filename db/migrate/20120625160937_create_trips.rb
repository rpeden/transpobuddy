class CreateTrips < ActiveRecord::Migration
  def up
  	create_table :trips do |t|
  		t.string  :trip_id
  		t.string  :route_id
  		t.string  :service_id
  		t.string  :trip_headsign
  		t.integer :block_id
  	end
  	add_index :trips, :trip_id
  end

  def down
  end
end
