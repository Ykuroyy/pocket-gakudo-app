namespace :attendance do
  desc "既存の出欠席データに対して初期の変更履歴を作成"
  task create_initial_histories: :environment do
    puts "既存の出欠席データに対して初期の変更履歴を作成しています..."
    
    Attendance.find_each do |attendance|
      # 既に変更履歴がある場合はスキップ
      next if attendance.attendance_histories.exists?
      
      # parent_nameが空の場合はスキップ
      next if attendance.parent_name.blank?
      
      # 初期の変更履歴を作成（作成時点での状態）
      attendance.attendance_histories.create!(
        status: attendance.status,
        message: attendance.message,
        child_name: attendance.child_name,
        date: attendance.date,
        parent_name: attendance.parent_name,
        changed_by: 'parent', # 初期データは保護者による作成と仮定
        changed_at: attendance.created_at
      )
      
      print "."
    end
    
    puts "\n初期の変更履歴の作成が完了しました。"
  end
end 