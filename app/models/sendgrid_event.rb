class SendgridEvent < ActiveRecord::Base
  
  after_create :queue
    
  def queue
    Delayed::Job.enqueue(self)
  end
  
  # delayed job method
  def perform
    # aqui entra o código de post , etc
  end
  
end