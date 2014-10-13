class CreateShipments < ActiveRecord::Migration
  def change
  	create_table :shipments do |t|
  		t.text :scope
		t.text :name
		t.text :phone
		t.text :address

  		t.timestamps
  	end
  end
end
