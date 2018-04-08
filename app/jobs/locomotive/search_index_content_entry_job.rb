module Locomotive

  class SearchIndexContentEntryJob < BaseSearchJob

    def perform(entry_id, locale)
      ::Mongoid::Fields::I18n.with_locale(locale) do
        entry = Locomotive::ContentEntry.find(entry_id)

        index_content_entry(entry.site, entry, locale)
      end
    end

  end

end
