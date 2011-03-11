post "/sendgrid_event.json" do
  request.body.rewind
  data = JSON.parse(request.body.read)
  data.inspect
end

# para testar:
# curl -H 'Content-Type: application/json' -d "{\"val\":\"var\"}" -X POST http://localhost:4567/sendgrid_event.json > error.html