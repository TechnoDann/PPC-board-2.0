# frozen_string_literal: true
Rails.application.config.action_mailer.delivery_method = :smtp
# Special sauce for a heroku-based gmail-using mailer
if ENV['SENDGRID_USERNAME'] && ENV['SENDGRID_PASSWORD']
  Rails.application.config.action_mailer.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
  Rails.application.config.action_mailer.default_url_options = {
    :host => 'ppc-posting-board-2-proto.herokuapp.com',
    :only_path => false }
else
  Rails.application.config.action_mailer.smtp_settings =
    YAML.load_file(Rails.root.join('config', 'mailers.yml'))[Rails.env].to_options
end
