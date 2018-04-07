require 'algoliasearch'

module Locomotive
  module Search
    module Backend

      class Algolia

        attr :site, :locale, :client

        def initialize(site, locale)
          @site, @locale = site, locale

          if site.metafields['algolia']
            credentials  = site.metafields['algolia'].slice('application_id', 'api_key').symbolize_keys
            @client      = ::Algolia::Client.new(credentials)
          end
        end

        # Add the object to 2 indices:
        # - global: in order to perform a global search among all the entities: page, content entries
        # - object: in order to perform a local search among the pages or a content type
        #
        # Names of the indices:
        # - global: locomotive-<Rails env>-<site id>-<locale>
        # - object: locomotive-<Rails env>-<site id>-<locale>-<type: page or a content type>
        #
        def save_object(type: nil, object_id: nil, title: nil, content: nil, visible: true, data: {})
          object = {
            title:      title,
            type:       type,
            content:    content,
            objectID:   object_id,
            visible:    visible,
            data:       data
          }

          object_index(type).save_objects([object])
          global_index.save_objects([object])
        end

        def delete_object(type, object_id)
          object_type_index(type).delete_object(object_id)
          global_index.delete_object(object_id)
        end

        def enabled?
          @client.present?
        end

        def global_index
          name = ['locomotive', Rails.env, self.site._id, self.locale].join('-')
          ::Algolia::Index.new(name, self.client)
        end

        def object_index(type)
          name = ['locomotive', Rails.env, self.site._id, self.locale, type].join('-')
          ::Algolia::Index.new(name, self.client)
        end

      end

    end
  end
end
