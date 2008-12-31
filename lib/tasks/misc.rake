require 'lib/models/email'
require 'lib/models/user'

task :default => :environment do
  # just run tests, nothing fancy
  Dir["test/**/*.rb"].sort.each { |test|  load test }
end

# sends any scheduled emails
task :send_reminders => :environment do    
  Email.deliver_scheduled_emails
end

