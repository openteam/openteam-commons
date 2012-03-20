require 'airbrake'
require 'configliere'

module OpenteamCommons
  class Engine < ::Rails::Engine
    isolate_namespace OpenteamCommons

    config.before_configuration do
      Settings.read(Rails.root.join('config', 'settings.yml')) if Rails.root.join('config', 'settings.yml').exist?

      Settings.defaults Settings.extract!(Rails.env)[Rails.env] || {}
      Settings.extract!(:test, :development, :production)

      Settings.define 'app.secret',       :env_var => 'APP_SECRET'
      Settings.define 'app.url',          :env_var => 'APP_URL'

      Settings.define 'errors.key',       :env_var => 'ERRORS_KEY'
      Settings.define 'errors.url',       :env_var => 'ERRORS_URL'

      Settings.define 'solr.url',         :env_var => 'SOLR_URL'

      Settings.define 'sso.key',          :env_var => 'SSO_KEY'
      Settings.define 'sso.secret',       :env_var => 'SSO_SECRET'
      Settings.define 'sso.url',          :env_var => 'SSO_URL'

      Settings.define 'storage.url',      :env_var => 'STORAGE_URL'

      Settings.define 'unicorn.workers',  :env_var => 'STORAGE_URL'
      Settings.define 'unicorn.timeout',  :env_var => 'STORAGE_URL'
    end

    config.before_initialize do
      if Settings['errors.key'].present?
        Airbrake.configure do |config|
          config.api_key = Settings['errors.key']

          URI.parse(Settings['errors.url']).tap do | url |
            config.host   = url.host
            config.port   = url.port
            config.secure = url.scheme.inquiry.https?
          end
        end
      end
    end

    config.after_initialize do
      Rails.logger.level = ActiveSupport::BufferedLogger::Severity::WARN if Rails.env.production?
    end

    config.after_initialize do
      Rails.application.config.secret_token = Settings['app.secret']

      I18n.locale = I18n.default_locale
    end
  end
end
