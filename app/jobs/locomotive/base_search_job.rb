module Locomotive

  class BaseSearchJob < ApplicationJob

    queue_as :search

    protected

    def search_backend(site, locale)
      Rails.configuration.x.locomotive_search_backend.create(site, locale)
    end

    def index_page(site, page, locale)
      search_backend(site, locale)&.save_object(
        type:       'page',
        object_id:  page._id.to_s,
        title:      page.title,
        content:    page.content_to_index,
        visible:    page.published?,
        data:       page.data_to_index
      )
    end

    def index_content_entry(site, entry, locale)
      search_backend(entry.site, locale)&.save_object(
        type:       entry.content_type.slug,
        object_id:  entry._id.to_s,
        title:      entry._label,
        content:    entry.content_to_index,
        visible:    entry.visible?,
        data:       entry.data_to_index
      )
    end

  end

end
