class TableCreation < ActiveRecord::Migration
  	def change
  	  	create_table :Posts do |t|
  			t.text :name
  			t.text :content

  			t.timestamps null: false
  		end

  		create_table :Comments do |t|
  			t.belongs_to :post, index:true
  			t.text :content

  			t.timestamps null: false
  		end
 	end
end
