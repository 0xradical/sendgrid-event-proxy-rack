DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/production.db")

class SendgridEvent
  
  include DataMapper::Resource
  
  property :id,       Serial
  property :event,    String
  property :email,    String
  property :category, String
  property :reason,   String
  property :response, String
  property :attempt,  String
  property :reason,   String
  property :type,     String
  property :status,   String
  property :url,      String
  
end

DataMapper.auto_upgrade!