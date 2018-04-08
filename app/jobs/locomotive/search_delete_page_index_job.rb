module Locomotive

  class SearchDeletePageIndexJob < BaseSearchJob

    def perform(page_id, locale)
      ::Mongoid::Fields::I18n.with_locale(locale) do
        page = Locomotive::Page.find(page_id)

        search_backend(page.site, locale)&.delete_object('page', page_id)
      end
    end

  end

end
