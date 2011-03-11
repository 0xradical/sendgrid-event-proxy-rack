require 'rubygems'
require 'bundler'

Bundler.require

post "/sendgrid_event.json" do
  request.body.rewind
  data = JSON.parse(request.body.read)
  data.inspect
end