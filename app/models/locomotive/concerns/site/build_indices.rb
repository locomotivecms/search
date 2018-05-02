module Locomotive
  module Concerns
    module Site

      module BuildIndices

        extend ActiveSupport::Concern

        included do

          after_validation  :check_for_building_search_indices
          before_save       :search_reset_done!,    if: :building_search_indices?
          after_save        :build_search_indices,  if: :building_search_indices?
          after_destroy     :clear_search_indices,  if: :search_enabled?

        end

        private

        def building_search_indices?
          !!@building_search_indices
        end

        def check_for_building_search_indices
          @building_search_indices = search_reset?
        end

        def build_search_indices
          Locomotive::SearchIndexSiteJob.perform_later(self._id.to_s)
        end

        def clear_search_indices
          Locomotive::SearchDeleteSiteIndicesJob.perform_later(
            self.handle,
            self.metafields.to_json
          )
        end

        def search_reset?
          Rails.configuration.x.locomotive_search_backend.reset_for?(self)
        end

        def search_reset_done!
          Rails.configuration.x.locomotive_search_backend.reset_done!(self)
        end

        def search_enabled?
          Rails.configuration.x.locomotive_search_backend.enabled_for?(self)
        end

      end

    end
  end
end
