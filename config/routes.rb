Rails.application.routes.draw do
  devise_for :users

  resources :votes, only: [:create, :destroy]

  resources :questions, shallow: true do
    resources :attachments
    resources :answers, shallow: true do
      resources :attachments
      patch :set_best, on: :member
    end
  end

  root to: "questions#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
