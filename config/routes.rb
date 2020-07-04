# frozen_string_literal: true

Rails.application.routes.draw do
  resources :hello_world, only: [:index]
  resources :users
  resources :sessions, only: [:create]
  resources :products
  resources :transactions
  resources :orders
  resources :ratings, only: [:create]
  resources :deposits, only: [:create]
end
