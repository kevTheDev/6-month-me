task :default => :environment do
  # just run tests, nothing fancy
  Dir["test/**/*.rb"].sort.each { |test|  load test }
end

# sends any scheduled emails
task :send_reminders => :environment do
  
  Email.scheduled_emails.each do |email|
    Pony.mail(:to => email.address, :from => 'noreply@sixmonthsme.com', :subject => 'A Letter From Your Past', :body => email.content)
  end
  
end

