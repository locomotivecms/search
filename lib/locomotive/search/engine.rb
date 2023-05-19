module Locomotive
  module Search
    class Engine < ::Rails::Engine

      initializer 'locomotive.search.backend' do |app|
        if backend_name = app.config.x.locomotive_search_backend
          app.config.x.locomotive_search_backend = BackendFactory.new(backend_name)
        end
      end

      initializer 'locomotive.search.zeitwerk' do
        ActiveSupport::Dependencies.autoload_paths.delete("#{Engine.root}/app/decorators")
      end
      
      # Allow the plugin to change the behavior of Locomotive controllers and
      # models in a clean way.
      config.to_prepare do
        Dir.glob(Engine.root + 'app/decorators/**/*_decorator*.rb').each do |decorator|
          load decorator
        end
      end

    end
  end
end
