module Locomotive

  class SearchIndexPageJob < BaseSearchJob

    def perform(page_id, locale)
      ::Mongoid::Fields::I18n.with_locale(locale) do
        page = Locomotive::Page.find(page_id)

        search_backend(page.site, locale)&.save_object(
          type:       'page',
          object_id:  page_id,
          title:      page.title,
          content:    page.content_to_index,
          visible:    page.published?,
          data:       page.data_to_index
        )
      end
    end

  end

end
