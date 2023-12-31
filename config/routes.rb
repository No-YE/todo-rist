# frozen_string_literal: true

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount GoodJob::Engine => '/good_job'
    mount Motor::Admin => '/admin'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'root#index'

  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :links, only: %i[index create new destroy] do
    collection do
      get 'others' => 'links#others'
    end
    member do
      put 'read' => 'links#read'
      put 'unread' => 'links#unread'
      post 'clone' => 'links#clone'
    end
  end

  namespace :admin do
    resources :links, only: [] do
      collection do
        post 'initial' => 'links#create_initial'
      end
    end
  end
end
