# Pocket学童 - 学童保育出欠席連絡アプリ

## 📱 アプリ概要

**Pocket学童**は、学童保育の欠席連絡をWebアプリで簡単に行えるようにしたRailsアプリケーションです。

### 主な特徴
- **保護者**: スマホやPCから簡単に欠席連絡ができる
- **管理者**: リアルタイムで出欠席状況を確認できる
- **変更履歴**: 連絡内容の変更履歴も記録・確認可能
- **複数のお子様対応**: 1つのアカウントで複数のお子様を管理

## 🛠️ 技術スタック

- **フレームワーク**: Ruby on Rails 8.0
- **データベース**: SQLite3 (開発) / PostgreSQL (本番)
- **フロントエンド**: Tailwind CSS
- **デプロイ**: Render
- **開発支援**: AI (Cursor)

## ✨ 主な機能

### 保護者向け機能
- 📝 出欠席連絡の送信（出席・欠席・遅刻・早退）
- 📅 日付別の連絡履歴確認
- ✏️ 連絡内容の編集
- 📋 変更履歴の確認
- 👶 複数のお子様対応

### 管理者向け機能
- 📊 全員の出欠席状況一覧
- 🔍 保護者連絡先情報の確認
- 📈 統計情報の表示
- 📋 変更履歴の確認

## 🚀 セットアップ

### 前提条件
- Ruby 3.3.0以上
- Rails 8.0以上
- SQLite3

### インストール手順

1. リポジトリをクローン
```bash
git clone https://github.com/Ykuroyy/pocket-gakudo-app.git
cd pocket-gakudo-app
```

2. 依存関係をインストール
```bash
bundle install
```

3. データベースをセットアップ
```bash
rails db:create
rails db:migrate
```

4. 初期データを作成（オプション）
```bash
rails attendance:create_initial_histories
```

5. サーバーを起動
```bash
rails server
```

6. ブラウザでアクセス
```
http://localhost:3000
```

## 👥 ユーザー登録

### 保護者アカウント
- 新規登録ページから保護者アカウントを作成
- 姓・名・パスワードを設定
- パスワードは6桁の半角数字と半角英語の組み合わせ

### 管理者アカウント
- 環境変数 `CREATE_DEFAULT_ADMIN=true` で初期管理者を作成
- デフォルトID: `admin`
- デフォルトパスワード: `admin123`

## 📊 データベース設計

### 主要テーブル
- `users`: ユーザー情報（保護者・管理者）
- `attendances`: 出欠席情報
- `attendance_histories`: 変更履歴

### リレーション
```ruby
User (保護者) → Attendance (1対多)
Attendance → AttendanceHistory (1対多)
```

## 🔧 環境変数

### 開発環境
```bash
# .env ファイルを作成
CREATE_DEFAULT_ADMIN=true
```

### 本番環境（Render）
```bash
CREATE_DEFAULT_ADMIN=false
DATABASE_URL=postgresql://...
```

## 📈 今後の改善予定

- [ ] プッシュ通知機能
- [ ] 月別レポート機能
- [ ] メール通知機能
- [ ] モバイルアプリ化
- [ ] カレンダー連携機能

## 🤝 開発について

このアプリは、プログラミング初心者がAI（Cursor）の力を借りて開発しました。

### 開発で学んだこと
- AIとの協働開発の効率性
- Railsの基本的な仕組み
- ユーザビリティの重要性
- データの整合性管理

### 開発のきっかけ
友人との食事中に聞いた「学童の欠席連絡が電話でしかできなくて大変」という話がきっかけで開発を始めました。

## 🔗 関連リンク

- [デモサイト](https://pocket-gakudo-app.onrender.com)
- [開発記録（Qiita）](https://qiita.com/your-username/items/...)

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 🙏 謝辞

- AI（Cursor）の開発支援
- Ruby on Railsコミュニティ
- 学童保育関係者の皆様

---

**最後に**
このアプリが、同じように学童の連絡で困っている方々の役に立てれば嬉しいです。
