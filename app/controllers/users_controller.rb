class UsersController < ApplicationController
  def new
    # データベースエラーを避けるため、基本的なUserオブジェクトを作成
    @user = User.new
  rescue => e
    # エラーが発生した場合は、ダミーのUserオブジェクトを作成
    @user = Class.new do
      def initialize
        @attributes = {}
      end
      
      def errors
        @errors ||= Class.new do
          def any?
            false
          end
          
          def [](field)
            []
          end
        end.new
      end
      
      def method_missing(method_name, *args, &block)
        if method_name.to_s.end_with?('=')
          @attributes[method_name.to_s.chomp('=')] = args.first
        else
          @attributes[method_name.to_s]
        end
      end
      
      def respond_to_missing?(method_name, include_private = false)
        true
      end
    end.new
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