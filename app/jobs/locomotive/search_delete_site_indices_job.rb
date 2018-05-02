module Locomotive
  class SearchDeleteSiteIndicesJob < BaseSearchJob

    def perform(handle, metafields)
      site = Locomotive::Site.new(
        handle:       handle,
        metafields:   JSON.parse(metafields)
      )
      search_backend(site, nil)&.clear_all_indices
    end

  end
end
