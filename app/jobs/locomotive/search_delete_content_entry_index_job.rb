module Locomotive
  class SearchDeleteContentEntryIndexJob < BaseSearchJob

    def perform(site_id, content_type_slug, entry_id, locale)
      ::Mongoid::Fields::I18n.with_locale(locale) do
        site = Locomotive::Site.where(_id: site_id).first

        return if site.nil? # usecase: the site has already been destroyed

        search_backend(site, locale)&.delete_object(
          content_type_slug,
          entry_id
        )
      end
    end

  end
end
