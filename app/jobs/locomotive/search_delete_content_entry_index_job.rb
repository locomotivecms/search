module Locomotive

  class SearchDeleteContentEntryIndexJob < BaseSearchJob

    def perform(site_id, content_type_slug, entry_id, locale)
      ::Mongoid::Fields::I18n.with_locale(locale) do
        site  = Locomotive::Site.find(site_id)
        entry = Locomotive::ContentEntry.find(entry_id)

        search_backend(site, locale)&.delete_object(
          content_type_slug,
          entry_id
        )
      end
    end

  end

end
