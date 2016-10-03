require 'airbrake'
require 'configliere'

module OpenteamCommons
  class Engine < ::Rails::Engine
    isolate_namespace OpenteamCommons

    config.before_configuration do
      read_settings
    end

    config.after_initialize do
      setup_airbrake
      setup_locale
      setup_secret if Rails.version.to_f < 4.1
    end

    def read_settings
      Settings.read(Rails.root.join('config', 'settings.yml')) if Rails.root.join('config', 'settings.yml').exist?

      Settings.defaults Settings.extract!(Rails.env)[Rails.env] || {}
      Settings.extract!(:test, :development, :production)

      Settings.define 'amqp.url',         env_var: 'AMQP_URL'

      Settings.define 'app.secret',       env_var: 'APP_SECRET'
      Settings.define 'app.url',          env_var: 'APP_URL'

      Settings.define 'errors.key',       env_var: 'ERRORS_KEY'
      Settings.define 'errors.url',       env_var: 'ERRORS_URL'

      Settings.define 'solr.url',         env_var: 'SOLR_URL'

      Settings.define 'sso.key',          env_var: 'SSO_KEY'
      Settings.define 'sso.secret',       env_var: 'SSO_SECRET'
      Settings.define 'sso.url',          env_var: 'SSO_URL'

      Settings.define 'storage.url',      env_var: 'STORAGE_URL'
    end

    def setup_airbrake
      if Settings['errors.key'].present?
        if Airbrake::AIRBRAKE_VERSION.to_i < 4
          Airbrake.configure do |config|
            config.api_key = Settings['errors.key']

            URI.parse(Settings['errors.url']).tap do |url|
              config.host   = url.host
              config.port   = url.port
              config.secure = url.scheme.inquiry.https?
            end
          end
        else
          Airbrake.configure do |config|
            config.project_key = Settings['errors.key']
            config.project_id = 1
            config.host = Settings['errors.url']
            config.environment = Rails.env
            config.ignore_environments = %w[development test]
          end
          ignore_errors = [
            'ActionController::RoutingError',
            'ActionView::Template::Error',
            'ActiveRecord::RecordNotFound',
          ]
          Airbrake.add_filter do |notice|
            if notice[:errors].any? { |error| ignore_errors.include? error[:type] }
              notice.ignore!
            end
          end
        end
      end
    end

    def setup_secret
      Rails.application.config.secret_token = Settings['app.secret']
    end

    def setup_locale
      I18n.locale = I18n.default_locale
    end
  end
end
