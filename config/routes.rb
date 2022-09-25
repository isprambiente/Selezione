# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :user do
    resources :careers
  end
  resources :contests, only: %i[index show]
  scope module: 'user' do
    resources :users, only: %i[] do
      resources :requests, except: %i[new destroy] do
        resources :additions
      end
    end
  end

  devise_for :users, prefix: 'auth'

  # Defines the root path route ("/")
  root 'contests#index'
end
