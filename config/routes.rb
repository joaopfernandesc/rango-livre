Rails.application.routes.draw do
  resources :hello_world, only: [:index]
  resources :user
  resources :sessions
  resources :products
  resources :transactions
  resources :orders
end
