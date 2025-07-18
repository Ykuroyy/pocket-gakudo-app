class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # セッション設定
  before_action :set_session_options

  helper_method :current_user, :current_user_role, :format_japanese_time

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_user_role
    session[:user_role]
  end

  def format_japanese_time(datetime)
    return "" unless datetime
    # UTC時間を日本時間（JST）に変換して表示
    jst_time = datetime.in_time_zone('Asia/Tokyo')
    jst_time.strftime("%m/%d %H:%M")
  end

  private

  def set_session_options
    # 本番環境でのセッション設定
    if Rails.env.production?
      session[:secure] = true
      session[:httponly] = true
    end
  end
end
