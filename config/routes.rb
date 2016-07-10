Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, only: [:new, :create, :edit, :update, :destroy] do
      member { patch :star }
    end
  end
  resources :attachments, only: :destroy
end
