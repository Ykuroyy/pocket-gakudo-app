require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PocketGakudoApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # 本番環境でマイグレーションを自動実行
    if Rails.env.production?
      config.after_initialize do
        begin
          ActiveRecord::Base.connection.execute("SELECT 1")
        rescue ActiveRecord::NoDatabaseError, PG::ConnectionBad
          # データベースが存在しない場合はスキップ
          Rails.logger.info "Database not available, skipping migration"
        rescue => e
          Rails.logger.error "Database connection error: #{e.message}"
        end
      end
    end
  end
end
