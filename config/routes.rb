Rails.application.routes.draw do
  resources :hello_world, only: [:index]
end
