class Attendance < ApplicationRecord
  validates :child_last_name, presence: { message: "お子様の姓を入力してください" }
  validates :child_first_name, presence: { message: "お子様の名を入力してください" }
  validates :status, presence: { message: "出欠状況を選択してください" }
  validates :date, presence: { message: "日付を選択してください" }
  
  # 同じ子供・同じ日付の重複送信を防ぐ
  validate :prevent_duplicate_attendance, on: :create
  
  # 子供のフルネームを取得
  def child_full_name
    if child_first_name.present? && child_last_name.present?
      "#{child_last_name} #{child_first_name}"
    else
      child_name
    end
  end

  private

  def prevent_duplicate_attendance
    return unless child_name.present? && date.present? && parent_name.present?
    
    existing_attendance = Attendance.where(
      child_name: child_name,
      date: date,
      parent_name: parent_name
    ).first
    
    if existing_attendance
      errors.add(:base, "同じ日付（#{date.strftime('%m月%d日')}）の出欠席連絡は既に送信済みです。修正が必要な場合は、既存の連絡を更新してください。")
    end
  end
end
