module Locomotive
  module Concerns
    module Search

      extend ActiveSupport::Concern

      included do

        after_save      :index_content,   if: :search_enabled?
        after_destroy   :unindex_content, if: :search_enabled?

      end

      private

      def search_enabled?
        Rails.configuration.x.locomotive_search_backend.enabled_for?(self.site)
      end

    end
  end
end
