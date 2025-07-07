class SessionsController < ApplicationController
  def new
    # ログインページを表示
  end

  def create
    # 保護者の場合、姓と名を組み合わせて認証
    if params[:role] == "parent" && params[:last_name].present? && params[:first_name].present?
      full_name = "#{params[:last_name]} #{params[:first_name]}"
      user = User.authenticate(full_name, params[:password])
    else
      # 管理者の場合、従来通り名前で認証
      user = User.authenticate(params[:name], params[:password])
    end
    
    if user
      session[:user_id] = user.id
      session[:user_name] = user.full_name
      session[:user_role] = user.role
      
      if user.parent?
        redirect_to parent_dashboard_path, notice: "ログインしました"
      elsif user.admin?
        redirect_to admin_dashboard_path, notice: "管理者としてログインしました"
      else
        redirect_to root_path, notice: "ログインしました"
      end
    else
      flash.now[:alert] = "名前またはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_name] = nil
    session[:user_role] = nil
    redirect_to root_path, notice: "ログアウトしました"
  end
end
