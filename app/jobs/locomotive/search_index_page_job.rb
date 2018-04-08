module Locomotive

  class SearchIndexPageJob < BaseSearchJob

    def perform(page_id, locale)
      ::Mongoid::Fields::I18n.with_locale(locale) do
        page = Locomotive::Page.find(page_id)

        index_page(page.site, page, locale)
      end
    end

  end

end
