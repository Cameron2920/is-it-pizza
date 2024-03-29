require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module IsItPizza
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.cam_password = ENV["CAM_PASSWORD"]
    config.cam_emails = ENV["CAM_EMAILS"]&.split(",")

    config.action_controller.asset_host = ENV["HOSTNAME"].nil? ? "http://localhost:3000" : "https://#{ENV["HOSTNAME"]}"
    config.action_mailer.asset_host = ENV["HOSTNAME"].nil? ? "http://localhost:3000" : "https://#{ENV["HOSTNAME"]}"
  end
end
