Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  concern :commentable do
    resources :comments, only: :create
  end

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :vote_cancel
    end
  end

  get '/users/:id/add_email_signup', to: 'additional_signups#add_email_signup', as: 'add_email_signup'
  patch '/users/finish_sign_up', to: 'additional_signups#finish_signup', as: 'finish_signup'

  resources :rewards, only: %i[index]
  resources :attachments, only: %i[destroy]

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, concerns: [:votable, :commentable] do
      member do
        patch :best
      end
    end
  end

  mount ActionCable.server => '/cable'
end
