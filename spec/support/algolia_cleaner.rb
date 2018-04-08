require 'algoliasearch'

module AlgoliaCleaner

  def self.delete_indices
    client = Algolia::Client.new(application_id: ENV['ALGOLIA_APPLICATION_ID'], api_key: ENV['ALGOLIA_API_KEY'])
    client.list_indexes['items'].each do |index|
      name = index['name']

      next unless name =~ /^locomotive-test/

      client.delete_index(index['name'])
    end
  end

end
