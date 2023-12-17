# frozen_string_literal: true

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount GoodJob::Engine => '/good_job'
    mount Motor::Admin => '/admin'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'root#index'

  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :links, only: %i[index create]
end
