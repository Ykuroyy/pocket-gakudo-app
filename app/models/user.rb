class User < ApplicationRecord
  validates :name, presence: { message: "名前を入力してください" }
  validates :password, presence: { message: "パスワードを入力してください" }
  validates :password, length: { is: 6, message: "パスワードは6桁で入力してください" }
  validates :password, format: { 
    with: /\A(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6}\z/, 
    message: "パスワードは半角数字と半角英語の組み合わせで6桁で入力してください" 
  }
  validates :role, presence: { message: "役割を選択してください" }
  validates :phone, presence: { message: "電話番号を入力してください" }
  validates :email, presence: { message: "メールアドレスを入力してください" }
  
  # 保護者の場合、姓と名のバリデーション
  validates :first_name, presence: { message: "名（カタカナ）を入力してください" }, if: :parent?
  validates :last_name, presence: { message: "姓（カタカナ）を入力してください" }, if: :parent?
  
  # フルネームを取得
  def full_name
    if first_name.present? && last_name.present?
      "#{last_name} #{first_name}"
    else
      name
    end
  end
  
  # ログイン認証メソッド（姓と名または従来の名前で認証）
  def self.authenticate(name, password)
    user = find_by(name: name)
    if user && user.password == password
      user
    else
      # 姓と名で検索
      user = find_by("first_name = ? OR last_name = ? OR CONCAT(last_name, ' ', first_name) = ?", name, name, name)
      if user && user.password == password
        user
      else
        nil
      end
    end
  end
  
  # 保護者かどうか
  def parent?
    role == "parent"
  end
  
  # 管理者かどうか
  def admin?
    role == "admin"
  end
end
