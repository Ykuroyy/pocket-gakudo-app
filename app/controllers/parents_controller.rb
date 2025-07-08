class ParentsController < ApplicationController
  before_action :require_parent_login

  def dashboard
    @user_name = session[:user_name]
  end

  def attendances
    @user_name = session[:user_name]
    # 現在ログインしている保護者が送信した出欠席履歴を取得
    all_attendances = Attendance.where(parent_name: @user_name).order(created_at: :desc)
    
    # 子供の名前ごとにグループ化
    @attendances_by_child = all_attendances.group_by(&:child_name)
    
    # 子供の名前のリスト（統計表示用）
    @child_names = @attendances_by_child.keys.sort
  end

  private

  def require_parent_login
    unless session[:user_id] && session[:user_role] == "parent"
      redirect_to login_path, alert: "保護者としてログインしてください"
    end
  end
end
