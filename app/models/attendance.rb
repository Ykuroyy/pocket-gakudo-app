class Attendance < ApplicationRecord
  has_many :attendance_histories, dependent: :destroy
  
  validates :child_last_name, presence: { message: "お子様の姓を入力してください" }
  validates :child_first_name, presence: { message: "お子様の名を入力してください" }
  validates :status, presence: { message: "出欠状況を選択してください" }
  validates :date, presence: { message: "日付を選択してください" }
  
  # 同じ子供・同じ日付の重複送信を防ぐ（新規作成時）
  validate :prevent_duplicate_attendance, on: :create
  
  # 編集時の重複チェック
  validate :prevent_duplicate_attendance_on_update, on: :update
  
  # 更新後に変更履歴を保存
  after_update :create_history_record, if: :should_create_history?
  
  # 保護者情報を取得
  def parent_user
    return nil unless parent_name.present?
    
    # 姓と名に分割
    names = parent_name.split(' ', 2)
    last_name = names[0]
    first_name = names[1]
    
    User.find_by(last_name: last_name, first_name: first_name, role: "parent")
  end
  
  # 子供のフルネームを取得
  def child_full_name
    if child_first_name.present? && child_last_name.present?
      "#{child_last_name} #{child_first_name}"
    else
      child_name
    end
  end
  
  # 変更履歴を取得
  def history_records
    attendance_histories.ordered_by_changed_at
  end

  private

  def should_create_history?
    # 重要なフィールドが変更された場合のみ履歴を作成
    saved_change_to_status? || saved_change_to_message? || saved_change_to_child_name?
  end

  def create_history_record
    attendance_histories.create!(
      status: status,
      message: message,
      child_name: child_name,
      date: date,
      parent_name: parent_name,
      changed_by: determine_changed_by,
      changed_at: Time.current
    )
  end

  def determine_changed_by
    # セッションからユーザーの役割を取得
    if defined?(session) && session[:user_role]
      session[:user_role]
    else
      'parent' # デフォルトは保護者
    end
  end

  def prevent_duplicate_attendance
    return unless child_name.present? && date.present? && parent_name.present?
    
    existing_attendance = Attendance.where(
      child_name: child_name,
      date: date,
      parent_name: parent_name
    ).first
    
    if existing_attendance
      errors.add(:base, "同じ日付（#{date.strftime('%m月%d日')}）の出欠席連絡は既に送信済みです。該当の日付から内容を変更してください。")
    end
  end

  def prevent_duplicate_attendance_on_update
    return unless child_name.present? && date.present? && parent_name.present?
    
    # 自分以外の同じ条件のレコードを検索
    existing_attendance = Attendance.where(
      child_name: child_name,
      date: date,
      parent_name: parent_name
    ).where.not(id: id).first
    
    if existing_attendance
      errors.add(:base, "同じ日付（#{date.strftime('%m月%d日')}）の出欠席連絡は既に送信済みです。該当の日付から内容を変更してください。")
    end
  end
end
