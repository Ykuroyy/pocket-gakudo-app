# 本番環境でのデータベースセットアップ
if Rails.env.production?
  Rails.application.config.after_initialize do
    begin
      # マイグレーションを実行
      puts "Running database migrations..."
      ActiveRecord::Migration.migrate
      puts "Database migrations completed successfully!"
    rescue => e
      puts "Migration error: #{e.message}"
      Rails.logger.error "Migration error: #{e.message}"
    end
  end
end 