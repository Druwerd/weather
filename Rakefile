# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

require 'yard'

YARD::Rake::YardocTask.new do |t|
 t.files   = ['lib/**/*.rb', 'app/controllers/**/*.rb', 'app/models/**/*.rb']
 t.options = ['--any', '--extra', '--opts']
 t.stats_options = ['--list-undoc']
end
