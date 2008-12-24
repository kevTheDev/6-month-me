#ENV['APP_ENV'] ||= 'development'
#ENV['APP_ROOT'] ||= "#{File.dirname(__FILE__)}"

APP_ENV = 'development'
APP_ROOT = "#{File.dirname(__FILE__)}"

def database_configuration_file
  File.join(File.dirname(__FILE__), 'database.yml')
end

def database_configuration
  YAML::load(ERB.new(IO.read(database_configuration_file)).result)
end