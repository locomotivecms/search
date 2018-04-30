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
        # - global: locomotive-<Rails env>-<site handle>-<locale>
        # - object: locomotive-<Rails env>-<site handle>-<locale>-<type: page or a content type>
        #
        def save_object(type: nil, object_id: nil, title: nil, content: nil, visible: true, data: {})
          base_object = { objectID: object_id, visible: visible, type: type }
          object      = { title: title, content: content, data: data }.merge(base_object)

          object_index(type).save_objects([data.merge(base_object)])
          global_index.save_objects([object])
        end

        def delete_object(type, object_id)
          object_type_index(type).delete_object(object_id)
          global_index.delete_object(object_id)
        end

        def clear_all_indices
          client.list_indexes['items'].each do |index_attributes|
            name = index_attributes['name']

            next unless name =~ /^#{self.base_index_name}-/

            ::Algolia::Index.new(name, self.client).clear_index
          end
        end

        def valid?
          @client.present?
        end

        def global_index
          name = [base_index_name, self.locale].join('-')
          ::Algolia::Index.new(name, self.client)
        end

        def object_index(type)
          name = [base_index_name, self.locale, type].join('-')
          ::Algolia::Index.new(name, self.client)
        end

        def base_index_name
          ['locomotive', Rails.env, self.site.handle].join('-')
        end

        def self.enabled_for?(site)
          site.metafields.present? &&
          site.metafields['algolia'].present? &&
          site.metafields['algolia']['application_id'].present? &&
          site.metafields['algolia']['api_key'].present?
        end

        def self.reset_for?(site)
          enabled_for?(site) &&
          [1, '1', true].include?(site.metafields['algolia']['reset'])
        end

        def self.reset_done!(site)
          site.metafields['algolia']['reset'] = false
        end

      end

    end
  end
end
