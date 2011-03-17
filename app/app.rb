module SendgridEventProxy
  class Application < Sinatra::Base
    
    post "/sendgrid_event" do
      SendgridEvent.create(params) rescue nil
      nil
    end
    
    # para testar:
    # curl -D - -d "event=processed&email=test" http://localhost:4567/sendgrid_event    
  end
end