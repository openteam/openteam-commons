$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'openteam-commons/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'openteam-commons'
  s.version     = OpenteamCommons::VERSION
  s.authors     = ['OpenTeam']
  s.email       = ['mail@openteam.ru']
  s.homepage    = 'https://github.com/openteam/openteam-commons'
  s.summary     = 'Summary of OpenteamCommons.'
  s.description = 'Description of OpenteamCommons.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'airbrake'
  s.add_dependency 'configliere'
  s.add_dependency 'rails'
  s.add_dependency 'unicorn'
  s.add_dependency 'whenever'
end
