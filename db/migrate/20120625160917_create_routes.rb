class CreateRoutes < ActiveRecord::Migration
  def up
  	create_table :routes do |t|
  		t.string :route_id
  		t.string :route_short_name
  	end
  	add_index :routes, :route_id
  end

  def down
  end
end
