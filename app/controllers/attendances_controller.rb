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

  def update
    @attendance = Attendance.find(params[:id])
    
    # 子供の姓と名を組み合わせてchild_nameに保存
    if attendance_params[:child_last_name].present? && attendance_params[:child_first_name].present?
      child_name = "#{attendance_params[:child_last_name]} #{attendance_params[:child_first_name]}"
    end
    
    if @attendance.update(attendance_params.merge(child_name: child_name))
      redirect_to attendances_index_path(child_name: @attendance.child_name), notice: '出欠席情報を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @attendance = Attendance.new(attendance_params)
    
    # 子供の姓と名を組み合わせてchild_nameに保存
    if @attendance.child_last_name.present? && @attendance.child_first_name.present?
      @attendance.child_name = "#{@attendance.child_last_name} #{@attendance.child_first_name}"
    end
    
    # 保護者の名前を保存
    @attendance.parent_name = session[:user_name] if session[:user_name].present?
    
    # 同じ日付の既存の送信があるかチェック
    existing_attendance = check_existing_attendance
    
    if existing_attendance
      # 既存の送信がある場合は、更新オプションを提供
      @existing_attendance = existing_attendance
      @show_update_option = true
      render :new, status: :unprocessable_entity
    elsif @attendance.save
      redirect_to attendances_index_path(child_name: @attendance.child_name), notice: '出欠席情報を送信しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_existing
    existing_attendance = Attendance.find(params[:id])
    
    if existing_attendance.update(attendance_params)
      redirect_to attendances_index_path(child_name: existing_attendance.child_name), 
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
      # 保護者は自分の子どもの出欠のみ表示
      if current_user&.full_name.present?
        @attendances = Attendance.where(child_name: current_user.full_name).order(created_at: :desc)
        @child_name = current_user.full_name
      else
        @attendances = Attendance.none
        @child_name = nil
      end
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
