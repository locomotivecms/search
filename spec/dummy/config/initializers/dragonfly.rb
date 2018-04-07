# Configure
Dragonfly.app(:engine).configure do
  plugin :imagemagick,
    convert_command:  `which convert`.strip.presence || '/usr/local/bin/convert',
    identify_command: `which identify`.strip.presence || '/usr/local/bin/identify'

  verify_urls true

  secret 'b32da66e7f5d6617139e3ba8c8d64a157858ddf40be8591ae581e97518f1df63'

  url_format '/images/dynamic/:job/:sha/:basename.:ext'

  fetch_file_whitelist /public/

  fetch_url_whitelist /.+/
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware, :engine
