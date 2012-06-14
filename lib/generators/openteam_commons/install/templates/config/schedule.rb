set :job_template, "/usr/local/bin/bash -l -c ':job'" if RUBY_PLATFORM =~ /freebsd/

every :day do
  rake 'cron'
end
