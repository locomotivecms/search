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
        return nil unless self.setup?

        backend = self.klass.new(site, locale)
        backend.valid? ? backend : nil
      end

      def name
        return nil unless self.setup?

        self.klass.name.demodulize.underscore
      end

      def setup?
        self.klass.present?
      end

      def enabled_for?(site)
        self.setup? && self.klass.enabled_for?(site)
      end

      def reset_for?(site)
        self.setup? && self.klass.reset_for?(site)
      end

      def reset_done!(site)
        self.setup? && self.klass.reset_done!(site)
      end

    end
  end
end
