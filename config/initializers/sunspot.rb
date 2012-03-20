begin
  require 'sunspot'

  Sunspot.config.solr.url = Settings['solr.url']
rescue LoadError
end
