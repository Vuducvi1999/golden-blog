Rails.application.routes.draw do
  get 'binhluan/create'
  root 'home#index'
  get "contact" => 'home#contact'
  get "about" => 'home#about'
  
  devise_for :users, controllers: { confirmations: 'users/confirmations',
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations' }
  
  
  namespace :dashboard do
    get '/' => "dashboard#index"
    resources :categories, except: %i[show]
    resources :posts, except: %i[show] do
      resources :comments, except: %i[show index]
    end
  end
  
  namespace :dashboard, path:"posts", as:"post"  do
    resources :posts, path:'', as:'', only: %i[show] do
      post "binhluan" => "binhluan#create"
    end
  end


  
end
