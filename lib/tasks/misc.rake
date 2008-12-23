task :default do
  # just run tests, nothing fancy
  Dir["test/**/*.rb"].sort.each { |test|  load test }
end

# start thin
task :start_server do
  system "thin -C thin/development_config.yml -R thin/config.ru start"
end

# stop thin
task :stop_server do
end