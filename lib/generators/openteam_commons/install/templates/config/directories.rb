class Directories
  def root
    @root ||= File.expand_path('../..', __FILE__)
  end

  def group
    @group ||= root.split('/')[-2]
  end

  def project
    @project ||= root.split('/')[-1]
  end

  def config(file=nil)
    "#{root}/config/#{file}"
  end

  def log(file=nil)
    @log_dir ||= begin
                   FileUtils.mkdir_p("/var/log/#{group}/#{project}")
                   "/var/log/#{group}/#{project}/#{file}"
                 rescue Errno::EACCES
                   "#{root}/log/#{file}"
                 end
  end

  def pid_file
    @pid_file ||= begin
                    FileUtils.mkdir_p("/var/run/#{group}")
                    p "/var/run/#{group}/#{project}.pid"
                  rescue Errno::EACCES
                    p "/tmp/#{group}-#{project}.pid"
                  end
  end

  def heroku?
    ENV['PORT']
  end

end
