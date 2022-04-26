# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  resources :themes, only: [:index, :create]
  resources :squares, only: [:index, :show, :create]
  resources :boards, only: [:create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
