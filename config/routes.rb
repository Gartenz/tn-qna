Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :vote_cancel
    end
  end


  resources :rewards, only: %i[index]
  resources :attachments, only: %i[destroy]

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, concerns: [:votable] do
      member do
        patch :best
      end
    end
  end
end
