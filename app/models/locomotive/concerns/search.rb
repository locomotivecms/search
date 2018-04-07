module Locomotive
  module Concerns
    module Search

      private

      def search_enabled?
        Rails.configuration.x.locomotive_search_backend.create(
          self.site,
          ::Mongoid::Fields::I18n.locale.to_s
        ).present?
      end

    end
  end
end
