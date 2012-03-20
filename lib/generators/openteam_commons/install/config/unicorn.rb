current_dir = File.expand_path('../..', __FILE__)

group, project = current_dir.split('/')[-2..-1]

settings = YAML.load_file "#{current_dir}/config/settings.yml"

settings['unicorn'] ||= {}

worker_processes  (settings['unicorn']['workers'] || 2).to_i
timeout           (settings['unicorn']['timeout'] || 300).to_i
preload_app       true

if ENV['PORT'] # Heroku evironment
  listen            ENV['PORT'].to_i, :tcp_nopush => false
else
  listen            "/tmp/#{group}-#{project}.sock", :backlog => 64
  pid               "/var/run/#{group}/#{project}.pid"
  stdout_path       "/var/log/#{group}/#{project}/stdout.log"
  stderr_path       "/var/log/#{group}/#{project}/stderr.log"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
