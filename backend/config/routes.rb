# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :news, only: [:index]
    resources :github_events, only: %i[create index]
  end
end
