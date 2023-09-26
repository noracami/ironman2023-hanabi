Rails.application.routes.draw do
  resources :game_rooms
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "game_rooms#index"
end
