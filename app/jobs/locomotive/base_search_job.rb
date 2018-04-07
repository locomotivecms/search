module Locomotive

  class BaseSearchJob < ApplicationJob

    queue_as :search

    protected

    def search_backend(site, locale)
      Rails.configuration.x.locomotive_search_backend.create(site, locale)
    end

  end

end
