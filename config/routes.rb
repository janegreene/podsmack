Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  resources :users, only: [:new, :create]
  get '/dashboard', to: 'users#show'

  resources :producers, only: [:show]

end
