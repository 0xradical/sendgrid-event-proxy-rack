module SendgridEventProxy
  class Application < Sinatra::Base
    
    post "/sendgrid_event.json" do
      request.body.rewind
      data = JSON.parse(request.body.read)
      SendgridEvent.create(data) rescue nil
      nil
    end

    # para testar:
    # curl -H 'Content-Type: application/json' -d "{\"event\":\"processed\",\"email\":\"example@example.org\"}" -X POST http://localhost:4567/sendgrid_event.json
  end
end