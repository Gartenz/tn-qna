require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda{ |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  concern :commentable do
    resources :comments, only: :create
  end

  concern :subscribable do
    member do
      patch :subscribe
    end
  end

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :vote_cancel
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow:true
      end
    end
  end

  get '/users/add_email_signup', to: 'additional_signups#add_email_signup', as: 'add_email_signup'
  post '/users/finish_sign_up', to: 'additional_signups#finish_signup', as: 'finish_signup'
  get '/search', to: 'searches#search', as: 'search'

  resources :rewards, only: %i[index]
  resources :attachments, only: %i[destroy]

  resources :questions, concerns: [:votable, :commentable] do
    resources :subscriptions, only: %i[create destroy], shallow:true

    resources :answers, shallow: true, concerns: [:votable, :commentable] do
      member do
        patch :best
      end
    end
  end

  mount ActionCable.server => '/cable'


end
