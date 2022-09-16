# frozen_string_literal: true

Rails.application.routes.draw do
  resources :contests, only: %i[index show]
  resources :requests, except: %i[new]

  devise_for :users

  # Defines the root path route ("/")
  root 'contests#index'
end
