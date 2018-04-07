module Locomotive
  module Search

    class BackendFactory

      attr_reader :klass

      def initialize(name_or_klass)
        if name_or_klass.is_a?(Symbol) || name_or_klass.is_a?(String)
          begin
            require_relative "./backend/#{name_or_klass}"
            @klass = "Locomotive::Search::Backend::#{name_or_klass.to_s.camelize}".constantize
          rescue LoadError
            raise UnknownBackendError.new("'#{name_or_klass}' is not a valid backend")
          end
        else
          @klass = name_or_klass
        end
      end

      def create(site, locale)
        backend = klass.new(site, locale)
        backend.enabled? ? backend : nil
      end

    end
  end
end
