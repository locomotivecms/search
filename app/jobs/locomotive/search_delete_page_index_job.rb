module Locomotive

  class SearchDeletePageIndexJob < BaseSearchJob

    def perform(site_id, page_id, locale)
      ::Mongoid::Fields::I18n.with_locale(locale) do
        site = Locomotive::Site.find(site_id)

        search_backend(site, locale)&.delete_object('page', page_id)
      end
    end

  end

end
