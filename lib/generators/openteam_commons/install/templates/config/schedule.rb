if RUBY_PLATFORM =~ /freebsd/
  set :job_template, "/usr/local/bin/bash -l -i -c ':job'"
else
  set :job_template, "/bin/bash -l -i -c ':job'"
end

every :day do
  rake 'cron'
end
