source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in search.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'passenger',              '~> 6.0.14'
gem 'mongoid',                '~> 6.4.0'
gem 'devise',                 '~> 4.7.3'
gem 'sass-rails',             '~> 5.0'
gem 'uglifier',               '>= 1.3.0'
gem 'coffee-rails',           '~> 4.2'
gem 'turbolinks',             '~> 5'
gem 'bootsnap',               '>= 1.1.0', require: false
gem 'sidekiq',                '~> 5.1.3'

# gem 'custom_fields', path: '../custom_fields' # for Developers
# gem 'locomotivecms', path: '../engine'
# gem 'locomotivecms_steam', path: '../steam'
# gem 'locomotivecms_common', path: '../common'
gem 'locomotivecms', '>= 4.1.0.rc1'

group :development, :test do
  gem 'rspec-rails',              '~> 3.7'
  gem 'factory_bot_rails',        '~> 4.8.2'
  gem 'database_cleaner',         '~> 1.6.2'
  gem 'dotenv-rails',             '~> 2.4.0', require: 'dotenv/rails-now'
end

# To use a debugger
gem 'byebug', group: [:development, :test]
