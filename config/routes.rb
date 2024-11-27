Rails.application.routes.draw do
  # Define your application routes per the DSL in
  # https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no
  # exceptions, otherwise 500.  Can be used by load balancers and uptime
  # monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  devise_for(
    :users,
    path: "/api",
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "signup",
    },
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
    },
  )

  namespace :api do
    devise_scope :user do
      resource :reset_password, only: %i[create update]
    end

    resources :age_ratings, only: %i[index show destroy]
    resources :artworks, only: %i[index show destroy]
    resources :companies, only: %i[index show destroy]
    resources :covers, only: %i[index show destroy]
    resources :games
    resources :game_modes, only: %i[index show destroy]
    resources :genres, only: %i[index show destroy]
    resources :involved_companies, only: %i[index show destroy]
    resources :platforms, only: %i[index show destroy]
    resources :release_dates, only: %i[index show destroy]
    resources :screenshots, only: %i[index show destroy]
    resources :users
  end
end
