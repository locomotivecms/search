require 'algolia'

module Locomotive
  module Search
    module Backend

      class Algolia < Base

        def self.backend_name
          'algolia'
        end

        def build_client(application_id:, api_key:)
          ::Algolia::Search::Client.create(application_id, api_key)
        end

        def index_for(index_name, client)
          client.init_index(index_name)
        end

        def index_objects(index, objects)
          index.save_objects(objects).wait
        end

        def delete_object(index, object_id)
          index.delete_object(object_id).wait
        end

        def clear_all_indices
          client.list_indexes[:items].each do |index_attributes|
            name = index_attributes[:name]

            next unless name =~ /^#{self.base_index_name}-/

            index_for(name, self.client).delete
          end
        end
      end

    end
  end
end
