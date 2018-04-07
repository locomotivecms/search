module Locomotive
  module Search
    class Engine < ::Rails::Engine

      initializer 'locomotive.search.backend' do |app|
        if backend_name = app.config.x.locomotive_search_backend
          app.config.x.locomotive_search_backend = BackendFactory.new(backend_name)
        end
      end

      # Allow the pkugin to change the behavior of Locomotive controllers and
      # models in a clean way.
      config.to_prepare do
        Dir.glob(Engine.root + 'app/decorators/**/*_decorator*.rb').each do |c|
          require_dependency(c)
        end
      end

    end
  end
end
