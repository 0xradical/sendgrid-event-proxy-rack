require 'active_record'

dbconfig = YAML.load_file(File.join(File.expand_path(File.join(File.dirname(__FILE__),'..')),'config','database.yml'))
ActiveRecord::Base.establish_connection(dbconfig[ENV["RACK_ENV"] || "development"])
