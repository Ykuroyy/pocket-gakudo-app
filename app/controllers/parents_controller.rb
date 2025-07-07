class ParentsController < ApplicationController
  before_action :require_parent_login

  def dashboard
    @user_name = session[:user_name]
  end

  def attendances
    @user_name = session[:user_name]
    # 保護者の子供の出欠席履歴を取得（実際の実装では、保護者と子供の関連付けが必要）
    @attendances = Attendance.where(child_name: "#{@user_name}の子供").order(created_at: :desc)
  end

  private

  def require_parent_login
    unless session[:user_id] && session[:user_role] == "parent"
      redirect_to login_path, alert: "保護者としてログインしてください"
    end
  end
end
