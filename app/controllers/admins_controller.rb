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

  def parent_info
    parent_name = params[:parent_name]
    # 姓と名に分割
    names = parent_name.split(' ', 2)
    last_name = names[0]
    first_name = names[1]
    
    parent_user = User.find_by(last_name: last_name, first_name: first_name, role: "parent")
    
    if parent_user
      render json: {
        phone: parent_user.phone,
        email: parent_user.email
      }
    else
      render json: {
        phone: nil,
        email: nil
      }
    end
  end

  private

  def require_admin_login
    unless session[:user_id] && session[:user_role] == "admin"
      redirect_to login_path, alert: "管理者としてログインしてください"
    end
  end
end
