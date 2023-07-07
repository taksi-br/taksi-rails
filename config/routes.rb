# frozen_string_literal: true

Taksi::Engine.routes.draw do
  resources :skeletons, only: [:show]
  resources :data, only: [:show]
end
