Rails.application.routes.draw do
  # ログイン関連
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # 新規登録関連
  get "signup", to: "users#new", as: :signup
  post "signup", to: "users#create"

  # 保護者ページ
  get "parents/dashboard", to: "parents#dashboard", as: :parent_dashboard
  get "parents/attendances", to: "parents#attendances", as: :parent_attendances

  # 管理者ページ
  get "admins/dashboard", to: "admins#dashboard", as: :admin_dashboard
  get "admins/attendances", to: "admins#attendances", as: :admin_attendances
  get "admins/all_attendances", to: "admins#all_attendances", as: :admin_all_attendances

  # 出欠席連絡のルート（保護者用）
  resources :attendances, except: [:show, :destroy] do
    member do
      patch :update_existing
    end
  end
  get "attendances", to: "attendances#index", as: :attendances_index
  
  # ルートページをログインページに変更
  root "sessions#new"
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
