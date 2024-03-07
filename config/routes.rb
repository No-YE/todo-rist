# frozen_string_literal: true

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount GoodJob::Engine => '/good_job'
    mount Motor::Admin => '/admin'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  root 'root#index'
  get 'direct_close' => 'root#direct_close', as: :direct_close
  get 'tos' => 'root#tos', as: :tos
  get 'privacy_policy' => 'root#privacy_policy', as: :privacy_policy

  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :users, only: %i[] do
    collection do
      get 'me' => 'users#me'
    end
  end
  namespace :users do
    resources :reminder_settings, only: %i[create update]
  end

  resources :links, only: %i[index show new create edit update destroy] do
    collection do
      get 'others' => 'links#others'
      get 'tags' => 'links#tags'
    end
    member do
      put 'read' => 'links#read'
      put 'unread' => 'links#unread'
      post 'clone' => 'links#clone'
    end

    scope module: :links do
      resource :records, only: %i[show create edit update destroy]
    end
  end

  resources :settings, only: %i[] do
    collection do
      get 'general' => 'settings#general'
      get 'notification' => 'settings#notification'
    end
  end

  resources :notifications, only: %i[index]

  namespace :admin do
    resources :links, only: [] do
      collection do
        post 'initial' => 'links#create_initial'
      end
    end
  end
end
