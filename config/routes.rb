Rails.application.routes.draw do
  devise_for :users

  # resources :votes, only: [:create, :destroy]

  resources :questions, shallow: true do
    resources :votes, only: [:create, :destroy]#, defaults: {votable: 'Questions'}
    resources :attachments
    resources :answers, shallow: true do
      resources :votes, only: [:create, :destroy]#, defaults: {votable: 'Answers'}
      resources :attachments
      patch :set_best, on: :member
    end
  end

  root to: "questions#index"
end
