lock '3.6.1'

set :application, 'deeprec'
set :repo_url, 'git@github.com:geneux/deep_recursion.git'

set :branch, ENV['BRANCH'] if ENV['BRANCH']

set :deploy_to, '/www/deeprec'
set :bundle_flags, '--deployment'
set :format, :airbrussh

append :linked_files, 'config/database.yml', 'config/private_pub.yml', 'config/private_pub.prod.yml',
       'config/secrets.yml', '.env', '.ruby-gemset', 'config/thinking_sphinx.yml'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads'

namespace :deploy do
  after :finishing, 'deploy:cleanup'
  after 'deploy:cleanup', 'deploy:restart'
  after 'deploy:restart', 'unicorn:restart'
end
