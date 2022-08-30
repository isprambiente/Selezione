# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :contests, only: %i[index show]

  # Defines the root path route ("/")
  root 'contests#index'
end
