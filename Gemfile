source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in search.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'rails',                  '~> 5.1.5'
gem 'passenger',              '~> 5.2.1'
gem 'mongoid',                '~> 6.3.0'
gem 'devise',                 '~> 4.4.3'
gem 'sass-rails',             '~> 5.0'
gem 'uglifier',               '>= 1.3.0'
gem 'coffee-rails',           '~> 4.2'
gem 'turbolinks',             '~> 5'
gem 'bootsnap',               '>= 1.1.0', require: false
gem 'sidekiq',                '~> 5.1.3'

gem 'locomotivecms', path: '../engine'

group :development, :test do
  gem 'rspec-rails',              '~> 3.7'
  gem 'factory_bot_rails',        '~> 4.8.2'
  gem 'database_cleaner',         '~> 1.6.2'
end

# To use a debugger
# gem 'byebug', group: [:development, :test]
