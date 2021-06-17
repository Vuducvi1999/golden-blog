Rails.application.routes.draw do
  root 'home#index'
  get "contact" => 'home#contact'
  get "sample_post" => 'home#sample_post'
  get "about" => 'home#about'
  
  devise_for :users, controllers: { confirmations: 'users/confirmations',
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations' }
  
  resources :categories, except: %i[show]
  
  resources :posts


  
end
