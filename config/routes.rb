# frozen_string_literal: true

Rails.application.routes.draw do
  resources :hello_world, only: [:index]
  resources :users
  resources :sessions, only: [:create]
  resources :products
  resources :transactions
  resources :orders
  resources :create, only: [:create]
  resources :deposit, only: [:create]
end
