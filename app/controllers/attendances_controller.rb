class AttendancesController < ApplicationController
  def new
    @attendance = Attendance.new
  end

  def edit
    @attendance = Attendance.find(params[:id])
    # 子供の名前を姓と名に分割
    if @attendance.child_name.present?
      names = @attendance.child_name.split(' ', 2)
      @attendance.child_last_name = names[0] if names[0]
      @attendance.child_first_name = names[1] if names[1]
    end
  end

  def history
    @attendance = Attendance.find(params[:id])
    @histories = @attendance.history_records
  end

  def update
    @attendance = Attendance.find(params[:id])
    
    # セッションにユーザーの役割を保存（変更履歴用）
    session[:user_role] = current_user_role
    
    # 子供の姓と名を組み合わせてchild_nameに保存
    child_name = nil
    if attendance_params[:child_last_name].present? && attendance_params[:child_first_name].present?
      child_name = "#{attendance_params[:child_last_name]} #{attendance_params[:child_first_name]}"
    end
    
    # 更新用のパラメータを準備
    update_params = attendance_params.dup
    update_params[:child_name] = child_name if child_name.present?
    
    # デバッグ情報
    Rails.logger.info "Update params: #{update_params}"
    Rails.logger.info "Child name: #{child_name}"
    
    if @attendance.update(update_params)
      redirect_to parent_dashboard_path, notice: '出欠席情報を更新しました'
    else
      # エラー情報をログに記録
      Rails.logger.error "Attendance update failed: #{@attendance.errors.full_messages}"
      render :edit, status: :unprocessable_entity
    end
  rescue => e
    # 予期しないエラーをキャッチ
    Rails.logger.error "Unexpected error in update: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    @attendance.errors.add(:base, "更新中にエラーが発生しました。もう一度お試しください。")
    render :edit, status: :unprocessable_entity
  end

  def create
    @attendance = Attendance.new(attendance_params)
    
    # 子供の姓と名を組み合わせてchild_nameに保存
    if @attendance.child_last_name.present? && @attendance.child_first_name.present?
      @attendance.child_name = "#{@attendance.child_last_name} #{@attendance.child_first_name}"
    end
    
    # 保護者の名前を保存
    @attendance.parent_name = session[:user_name] if session[:user_name].present?
    
    # デバッグ情報（本番環境では削除）
    Rails.logger.info "Creating attendance: #{@attendance.attributes}"
    Rails.logger.info "Session user_name: #{session[:user_name]}"
    
    # 同じ日付の既存の送信があるかチェック
    existing_attendance = check_existing_attendance
    
    if existing_attendance
      # 既存の送信がある場合は、更新オプションを提供
      @existing_attendance = existing_attendance
      @show_update_option = true
      render :new, status: :unprocessable_entity
    elsif @attendance.save
      redirect_to parent_dashboard_path, notice: '出欠席情報を送信しました'
    else
      # エラー情報をログに記録
      Rails.logger.error "Attendance save failed: #{@attendance.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  rescue => e
    # 予期しないエラーをキャッチ
    Rails.logger.error "Unexpected error in create: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    @attendance = Attendance.new(attendance_params)
    @attendance.errors.add(:base, "送信中にエラーが発生しました。もう一度お試しください。")
    render :new, status: :unprocessable_entity
  end

  def update_existing
    existing_attendance = Attendance.find(params[:id])
    
    if existing_attendance.update(attendance_params)
      redirect_to parent_dashboard_path, 
                  notice: '出欠席情報を更新しました'
    else
      @attendance = Attendance.new(attendance_params)
      @existing_attendance = existing_attendance
      @show_update_option = true
      render :new, status: :unprocessable_entity
    end
  end

  def index
    if current_user_role == "parent"
      # 保護者は保護者専用の出欠席一覧ページにリダイレクト
      redirect_to parent_attendances_path
    else
      # 管理者は全児童の出欠を表示
      if params[:child_name].present?
        @attendances = Attendance.where(child_name: params[:child_name]).order(created_at: :desc)
        @child_name = params[:child_name]
      else
        @attendances = Attendance.order(created_at: :desc)
        @child_name = nil
      end
    end
  end

  private

  def attendance_params
    params.require(:attendance).permit(:child_name, :child_first_name, :child_last_name, :status, :date, :message)
  end

  def check_existing_attendance
    return nil unless @attendance.child_name.present? && @attendance.date.present? && @attendance.parent_name.present?
    
    Attendance.where(
      child_name: @attendance.child_name,
      date: @attendance.date,
      parent_name: @attendance.parent_name
    ).first
  end
end
