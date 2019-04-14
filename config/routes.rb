Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  resources :attachments, only: %i[destroy]

  resources :questions do
    resources :answers, shallow: true do
      member do
        patch :best
      end
    end
  end
end
