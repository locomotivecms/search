source 'https://rubygems.org'

# Declare your gem's dependencies in search.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# gem 'locomotivecms', '>= 4.3'
gem 'locomotivecms', path: '../engine'

group :development, :test do
  gem 'rspec-rails',                '~> 6.0.1'
  gem 'factory_bot_rails',          '~> 6.2.0'
  gem 'database_cleaner-mongoid',   '~> 2.0.1'
  gem 'dotenv-rails',               '~> 2.8.1', require: 'dotenv/rails-now'
  gem 'debug',                      '>= 1.0.0'
end
