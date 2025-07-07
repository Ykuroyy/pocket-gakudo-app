class Attendance < ApplicationRecord
  validates :child_last_name, presence: { message: "お子様の姓を入力してください" }
  validates :child_first_name, presence: { message: "お子様の名を入力してください" }
  validates :status, presence: { message: "出欠状況を選択してください" }
  validates :date, presence: { message: "日付を選択してください" }
  
  # 子供のフルネームを取得
  def child_full_name
    if child_first_name.present? && child_last_name.present?
      "#{child_last_name} #{child_first_name}"
    else
      child_name
    end
  end
end
