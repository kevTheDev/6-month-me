ENV['APP_ENV'] ||= 'development'
ENV['APP_ROOT'] ||= "#{File.dirname(__FILE__)}"

APP_ENV = ENV['APP_ENV']
APP_ROOT = ENV['APP_ROOT']

def database_configuration_file
  File.join(File.dirname(__FILE__), 'database.yml')
end

def database_configuration
  YAML::load(ERB.new(IO.read(database_configuration_file)).result)
end

# def use_main_database(env="development")
#   db = File.dirname(__FILE__) + "/config/database.yml"
#   database_config = YAML.load(ERB.new(IO.read(db)).result)
#   (database_config[env]).symbolize_keys
# end
# 
# ActiveRecord::Base.establish_connection(use_main_database)

configure  do
  ActiveRecord::Base.configurations = database_configuration
  ActiveRecord::Base.establish_connection(APP_ENV)
  ActiveRecord::Base.logger = Logger.new("activerecord.log") # Somehow you need logging right?
end
