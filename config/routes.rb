Rails.application.routes.draw do
  root 'home#index'
  
  devise_for :users, controllers: { confirmations: 'users/confirmations',
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations' }
  
  resources :categories
  
  resources :posts


  
end
