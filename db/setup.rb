db_settings_hash = YAML.load_file("#{settings.root}/config/database.yml")

DataMapper.setup(:default, db_settings_hash[ENV['RACK_ENV']])

class SendgridEvent
  
  include DataMapper::Resource
  
  property :id,       Serial
  property :event,    String
  property :email,    String
  property :category, String
  property :reason,   String
  property :response, String
  property :attempt,  String
  property :type,     String
  property :status,   String
  property :url,      String
  
end

DataMapper.auto_upgrade!