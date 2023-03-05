module Locomotive
  module Search
    module Backend
      class Base

        attr_accessor :site, :locale, :client

        delegate :backend_name, :backend_client_klass, to: :class

        def initialize(site, locale)
          self.site, self.locale = site, locale

          if site.metafields[backend_name]
            credentials = site.metafields[backend_name].slice('application_id', 'api_key').symbolize_keys
            self.client = build_client(**credentials)
          end
        end

        def self.enabled_for?(site)
          site.metafields.present? && 
            site.metafields.dig(backend_name, 'application_id').present? &&
            site.metafields.dig(backend_name, 'api_key').present?
        end

        def self.reset_for?(site)
          enabled_for?(site) &&
            [1, '1', true].include?(site.metafields.dig(backend_name, 'reset'))
        end

        def self.reset_done!(site)
          site.metafields[backend_name]['reset'] = false
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

          index_objects(object_index(type), [data.merge(base_object)])
          index_objects(global_index, [object])
        end

        def delete_object(type, object_id)
          delete_object(object_index(type), object_id)
          delete_object(global_index, object_id)
        end

        def valid?
          @client.present?
        end

        def base_index_name
          ['locomotive', Rails.env, self.site.handle].join('-')
        end

        def global_index
          name = [base_index_name, self.locale].join('-')
          index_for(name, self.client)
        end

        def object_index(type)
          name = [base_index_name, self.locale, type].join('-')
          index_for(name, self.client)
        end
      end
    end
  end
end
