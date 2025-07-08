class AttendanceHistory < ApplicationRecord
  belongs_to :attendance
  
  validates :status, presence: true
  validates :child_name, presence: true
  validates :date, presence: true
  validates :parent_name, presence: true
  validates :changed_by, presence: true
  validates :changed_at, presence: true
  
  # 変更履歴を時系列順に取得
  scope :ordered_by_changed_at, -> { order(changed_at: :desc) }
  
  # 変更理由を取得
  def change_reason
    case changed_by
    when 'parent'
      '保護者による変更'
    when 'admin'
      '管理者による変更'
    else
      'システムによる変更'
    end
  end
  
  # 変更内容の要約を取得
  def change_summary
    parts = []
    parts << "出欠状況: #{status}"
    parts << "メッセージ: #{message.presence || 'なし'}" if message.present?
    parts.join(', ')
  end
end 