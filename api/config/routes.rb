Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  as :user do
    get "users/current", to: "users/registrations#show"
  end

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :accounts, only: %i[create destroy index show update]
  resources :categories, only: %i[index show]
  resources :sub_categories, only: %i[create destroy index show update]
  resources :transactions, only: %i[create destroy index show update]
end
