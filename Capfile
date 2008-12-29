require 'capistrano/version'
require 'rubygems'
require 'capinatra'
load 'deploy' if respond_to?(:namespace) # cap2 differentiator

# app settings
set :app_file, "init.rb"
set :application, "six_month_letter"
set :domain, "sixmonthletter.com"
role :app, domain
role :web, domain
role :db,  domain, :primary => true

# general settings
ssh_options[:port] = "30000"
set :user, "deploy"
set :group, "deploy"
set :deploy_to, "/var/www/apps/#{application}"
set :deploy_via, :remote_cache
set :password, "b5a3cda3"
default_run_options[:pty] = true

# scm settings
set :repository, "git@github.com:kevTheDev/6-month-me.git"
set :scm, "git"
set :branch, "master"
set :git_enable_submodules, 1

# where the apache vhost will be generated
set :apache_vhost_dir, "/etc/apache2/sites-enabled/"

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end