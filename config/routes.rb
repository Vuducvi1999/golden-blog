Rails.application.routes.draw do
  root 'home#index'
  get "contact" => 'home#contact'
  get "about" => 'home#about'
  
  devise_for :users, controllers: { confirmations: 'users/confirmations',
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations' }
  
  
  namespace :dashboard do
    get '/' => "dashboard#index"
    get 'manage/posts' => 'dashboard#manage_posts'
    resources :categories, path:'manage/categories', except: %i[show]
    resources :posts, except: %i[show] do
      resources :comments, except: %i[show index new edit]
      member do
        post 'approve_post'
        post 'reject_post'
        post 'like'
        post 'dislike'
        post 'rate'

      end
      collection do
        get 'search'
      end
    end
  end
  
  namespace :dashboard, path:"posts", as:"post"  do
    resources :posts, path:'', as:'', only: %i[show]
  end


  
end
