Rails.application.routes.draw do
  resources :contests, only: [:index, :show] do
    get :list, on: :collection
  end

  # Defines the root path route ("/")
  root "contests#index"
end
