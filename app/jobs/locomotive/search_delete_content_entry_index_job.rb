module Locomotive

  class SearchDeleteContentEntryIndexJob < BaseSearchJob

    def perform(entry_id, locale)
      ::Mongoid::Fields::I18n.with_locale(locale) do
        entry = Locomotive::ContentEntry.find(entry_id)

        search_backend(entry.site, locale)&.delete_object(
          entry.content_type.slug,
          entry_id
        )
      end
    end

  end

end
