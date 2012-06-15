module OpenteamCommons
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_binaries
        copy_file 'script/start_site'
        copy_file 'script/update_site'

        chmod 'script/start_site', 0755
        chmod 'script/update_site', 0755
      end

      def create_libs
        directory 'lib'
      end

      def create_configs
        directory 'config'
        copy_file 'Procfile'
      end
    end
  end
end

