Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

  concern :rateable do
    member do
      post :rate_inc
      post :rate_dec
      post :rate_revoke
    end
  end

  resources :questions, concerns: :rateable do
    resources :answers, only: [:new, :create, :edit, :update, :destroy],
        concerns: :rateable do
      member { patch :star }
    end
  end

  resources :attachments, only: :destroy
end
