require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HealthShark
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.secret_key_base = 'my_secret_key_base'

    ENV["REDISTOGO_URL"] = 'redis://redistogo:0aabf0e5dadf522d0da3099ba0bfb6c1@porgy.redistogo.com:11644/'

    config.gem 'redis'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
