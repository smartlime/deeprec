@wwwname = 'deeprec'
@bind_tcp = false

working_directory "/www/#{@wwwname}/current"
pid "/www/#{@wwwname}/shared/tmp/pids/unicorn.pid"
stdout_path "/www/#{@wwwname}/shared/log/unicorn.stdout.log"
stderr_path "/www/#{@wwwname}/shared/log/unicorn.stderr.log"

listen "/tmp/unicorn.#{@wwwname}.sock", backlog: 16

worker_processes 8
timeout 20

preload_app true

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "/www/#{@wwwname}/current/Gemfile"
end

before_fork do |server, worker|
  if defined? ActiveRecord::Base
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  if defined?(Resque)
    Resque.redis.quit
  end

  sleep 1
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  if defined?(Resque)
    Resque.redis = 'localhost:6379'
  end
end
