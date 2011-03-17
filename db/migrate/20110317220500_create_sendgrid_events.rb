class CreateSendgridEvents < ActiveRecord::Migration
  def self.up
    create_table :sendgrid_events do |t|
      t.string :event    
      t.string :email    
      t.string :category 
      t.string :reason  
      t.string :response
      t.string :attempt  
      t.string :type   
      t.string :status
      t.string :url    
    end                     
  end

  def self.down
    drop_table :sendgrid_events
  end
end
