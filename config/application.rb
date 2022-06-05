require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

SITE_KIND = :devel
if ENV["BOARD_SITE"]
  SITE_KIND = ENV["BOARD_SITE"].to_sym
end

SITE_CONFIG = HashWithIndifferentAccess.new(
  YAML.load_file(File.expand_path('../../config/sites.yml', __FILE__)))[SITE_KIND]

unless SITE_CONFIG.key?(:mail_host)
  SITE_CONFIG[:mail_host] = SITE_CONFIG[:app_host]
end

module PPCBoard20
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.active_record.schema_format = :sql

    config.time_zone = "UTC"
  end
end
