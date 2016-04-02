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
    if ENV['MAILGUN_SMTP_SERVER']
      config.action_mailer.smtp_settings = {
          :port           => ENV['MAILGUN_SMTP_PORT'],
          :address        => ENV['MAILGUN_SMTP_SERVER'],
          :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
          :password       => ENV['MAILGUN_SMTP_PASSWORD'],
          :domain         => 'ppc-posting-board-2-proto.heroku.com',
          :authentication => :plain,
      }
      config.action_mailer.default_url_options = {
        :host => 'ppc-posting-board-2-proto.herokuapp.com',
        :only_path => false }
    else
      config.action_mailer.smtp_settings =
        YAML.load_file(Rails.root.join('config', 'mailers.yml'))[Rails.env].to_options
    end
  end
end
