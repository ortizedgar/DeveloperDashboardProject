Rails.application.routes.draw do
  namespace :api do
    resources :news, only: [:index]
    resources :github_events, only: [:create]
  end
end
