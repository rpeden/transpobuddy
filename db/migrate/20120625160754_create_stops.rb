class CreateStops < ActiveRecord::Migration
  def up
  	create_table :stops do |t|
  		t.string :stop_id
  		t.string :stop_name
  		t.float  :stop_lat
  		t.float  :stop_lon
  	end
  	add_index :stops, [:stop_lat, :stop_lon]
  	add_index :stops, :stop_id
  end

  def down
  end
end
