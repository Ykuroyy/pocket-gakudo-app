class AttendancesController < ApplicationController
  def new
    @attendance = Attendance.new
  end

  def create
    @attendance = Attendance.new(attendance_params)
    
    # 子供の姓と名を組み合わせてchild_nameに保存
    if @attendance.child_last_name.present? && @attendance.child_first_name.present?
      @attendance.child_name = "#{@attendance.child_last_name} #{@attendance.child_first_name}"
    end
    
    if @attendance.save
      redirect_to attendances_index_path(child_name: @attendance.child_name), notice: '出欠席情報を送信しました'
    else
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
end
