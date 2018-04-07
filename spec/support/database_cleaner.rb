require 'database_cleaner'

module DatabaseCleaner
  def self.clean!
    ::Mongoid::Clients.default.collections.each do |collection|
      collection.drop
    end
  end
end
