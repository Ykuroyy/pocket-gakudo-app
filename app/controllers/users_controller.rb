class UsersController < ApplicationController
  def new
    # データベースエラーを避けるため、Userモデルを使わずにオブジェクトを作成
    @user = OpenStruct.new
    def @user.errors
      []
    end
    def @user.errors.any?
      false
    end
    def @user.errors.[](field)
      []
    end
  end

  def create
    @user = User.new(user_params)
    
    # 保護者の場合、姓と名を組み合わせてnameに保存
    if @user.role == "parent" && @user.first_name.present? && @user.last_name.present?
      @user.name = "#{@user.last_name} #{@user.first_name}"
    end
    
    if @user.save
      redirect_to login_path, notice: "登録が完了しました。ログインしてください。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :first_name, :last_name, :password, :role, :phone, :email)
  end
end 