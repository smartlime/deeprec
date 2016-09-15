Rails.application.routes.draw do
  use_doorkeeper

  root 'questions#index'

  devise_for :users, controllers: {omniauth_callbacks: :omniauth_callbacks}
  match 'account/confirm_email', via: [:get, :patch]

  concern :rateable do
    member do
      post :rate_inc
      post :rate_dec
      post :rate_revoke
    end
  end

  concern :commentable do
    resources :comments
  end

  resources :questions, concerns: [:rateable, :commentable], shallow: true do
    resources :answers, only: [:new, :create, :edit, :update, :destroy],
        concerns: [:rateable, :commentable] do
      member { patch :star }
    end
  end

  resources :answers do
    resources :comments, only: :create, defaults: {commentable: 'answers'}
  end

  resources :attachments, only: :destroy

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :all, on: :collection
      end

      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end
end
