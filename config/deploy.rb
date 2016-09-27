lock '3.6.1'

set :application, 'deeprec'
set :repo_url, 'git@github.com:geneux/deep_recursion.git'

set :branch, ENV['BRANCH'] if ENV['BRANCH']

set :deploy_to, '/www/deeprec'
set :bundle_flags, '--deployment'
set :format, :airbrussh

append :linked_files, 'config/database.yml', 'config/private_pub.yml', 'config/secrets.yml', '.env', '.ruby-gemset'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'
