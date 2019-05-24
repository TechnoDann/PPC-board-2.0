# frozen_string_literal: true
require File.expand_path('../boot', __FILE__)

require 'rails/all'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PPCBoard20
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.action_mailer.delivery_method = :smtp
    # Special sauce for a heroku-based gmail-using mailer
    if ENV['SENDGRID_USERNAME'] && ENV['SENDGRID_PASSWORD']
      config.action_mailer.smtp_settings = {
        :address        => 'smtp.sendgrid.net',
        :port           => '587',
        :authentication => :plain,
        :user_name      => ENV['SENDGRID_USERNAME'],
        :password       => ENV['SENDGRID_PASSWORD'],
        :domain         => 'heroku.com',
        :enable_starttls_auto => true
      }
      config.action_mailer.default_url_options = {
        :host => 'ppc-posting-board-2-proto.herokuapp.com',
        :only_path => false }
    else
      config.action_mailer.smtp_settings =
        YAML.load_file(Rails.root.join('config', 'mailers.yml'))[Rails.env].to_options
    end
    config.active_record.schema_format = :sql

    # Header sillyness
    config.action_dispatch.default_headers["X-Clacks-Overhead"] = "GNU Terry Pratchett"
  end
end
