require 'algolia'

module AlgoliaCleaner

  def self.delete_indices
    client = Algolia::Search::Client.create(ENV['ALGOLIA_APPLICATION_ID'], ENV['ALGOLIA_API_KEY'])

    client.list_indexes[:items].each do |index|
      name = index[:name]

      next unless name =~ /^locomotive-test/

      client.init_index(name).delete
    end
  end

end
