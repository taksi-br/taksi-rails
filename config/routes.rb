# frozen_string_literal: true

Taksi::Engine.routes.draw do
  resources :interfaces, only: [:show] do
    resources :data, only: [:index]
  end
end
