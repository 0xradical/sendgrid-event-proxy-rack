module SendgridEventProxy
  class Application < Sinatra::Base
    
    post "/sendgrid_event.json" do
      request.body.rewind
      data = JSON.parse(request.body.read)
      institution, model = data["category"].to_s.split("#")
      if institution
        institution_address = "http://#{institution}.domain.com/sendgrid_event.json"
        RestClient.post(institution_address, data.to_json, :content_type => :json, :accept => :json)
      end    
      nil
    end

    # para testar:
    # curl -H 'Content-Type: application/json' -d "{\"val\":\"var\"}" -X POST http://localhost:4567/sendgrid_event.json > error.html    
  end
end