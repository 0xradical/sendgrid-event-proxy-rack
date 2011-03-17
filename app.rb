module SendgridEventProxy
  class Application < Sinatra::Base
    
    post "/sendgrid_event.json" do
      request.body.rewind
      data = JSON.parse(request.body.read)
      # para teste apenas
      
      File.open('teste.yml','w') do |f|
        f.puts(data.to_yaml)
      end
      
      SendgridEvent.create(data) rescue nil
      nil
    end
    
    post /.*/ do
      request.body.rewind
      data = JSON.parse(request.body.read)
      # para teste apenas
      
      File.open('teste_2.yml','w') do |f|
        f.puts(request.to_yaml)
      end
      
    end

    # para testar:
    # curl -H 'Content-Type: application/json' -d "{\"event\":\"processed\",\"email\":\"example@example.org\"}" -X POST http://localhost:4567/sendgrid_event.json
  end
end