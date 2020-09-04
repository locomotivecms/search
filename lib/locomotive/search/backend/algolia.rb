require 'algoliasearch'

module Locomotive
  module Search
    module Backend

      class Algolia < Base

        def self.backend_name
          'algolia'
        end

        def self.backend_client_klass
          ::Algolia::Client
        end

        def index_for(index_name, client)
          ::Algolia::Index.new(index_name, client)
        end


      end

    end
  end
end
