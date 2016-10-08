Rails.application.routes.draw do
  root to: 'links#new'
  resources :links
  post "webhooks/github", to: 'webhooks#github'
  get "/auth/:provider/callback", to: 'sessions#create'
  get "/login", to: 'sessions#new'
end
