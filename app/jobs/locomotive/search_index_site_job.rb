module Locomotive

  class SearchIndexSiteJob < BaseSearchJob

    def perform(site_id)
      site = Locomotive::Site.find(site_id)

      # first remove all the indices for this site
      search_backend(site, nil)&.clear_all_indices

      # index the content in each locale
      site.each_locale do |locale|
        # index all the pages (except the 404 one)
        site.pages.each do |page|
          next if page.not_found?
          index_page(site, page, locale)
        end

        # index all the content entries
        site.content_types.each do |content_type|
          content_type.entries.each do |entry|
            index_content_entry(site, entry, locale)
          end
        end
      end

    end

  end

end
