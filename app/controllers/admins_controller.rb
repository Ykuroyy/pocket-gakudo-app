class AdminsController < ApplicationController
  before_action :require_admin_login

  def dashboard
    @user_name = session[:user_name]
    @total_attendances = Attendance.count
    @today_attendances = Attendance.where(date: Date.current).count
  end

  def attendances
    @user_name = session[:user_name]
    @attendances = Attendance.where(date: Date.current).order(created_at: :desc)
  end

  def all_attendances
    @user_name = session[:user_name]
    @attendances = Attendance.order(created_at: :desc)
  end

  private

  def require_admin_login
    unless session[:user_id] && session[:user_role] == "admin"
      redirect_to login_path, alert: "管理者としてログインしてください"
    end
  end
end
