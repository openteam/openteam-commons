def current_dir
  File.expand_path('../..', __FILE__)
end

def group
  current_dir.split('/')[-2]
end

def project
  current_dir.split('/')[-1]
end

def config_file_path
  "#{current_dir}/config/settings.yml"
end

def settings
  YAML.load_file(config_file_path)['unicorn'] || {}
end

def heroku?
  ENV['PORT']
end

def pid_file
  heroku? ? "/tmp/#{group}-#{project}.pid" : "/var/run/#{group}/#{project}.pid"
end

worker_processes  (settings['workers'] || 2).to_i
timeout           (settings['timeout'] || 300).to_i
preload_app       true
pid               pid_file

if heroku?
  listen            ENV['PORT'].to_i, :tcp_nopush => false
else
  listen            "/tmp/#{group}-#{project}.sock", :backlog => 64

  stdout_path       "/var/log/#{group}/#{project}/stdout.log"
  stderr_path       "/var/log/#{group}/#{project}/stderr.log"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{pid_file}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
