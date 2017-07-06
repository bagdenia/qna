Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post '/register' => 'omniauth_callbacks#register'
  end

  # resources :votes, only: [:create, :destroy]

  resources :questions, shallow: true do
    resources :comments, defaults: {commentable: 'questions'}
    resources :votes, only: [:create, :destroy], defaults: {votable: 'questions'}
    resources :attachments
    resources :answers, shallow: true do
      resources :comments, defaults: {commentable: 'answers'}
      resources :votes, only: [:create, :destroy], defaults: {votable: 'answers'}
      resources :attachments
      patch :set_best, on: :member
    end
  end

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
