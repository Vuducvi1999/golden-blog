Rails.application.routes.draw do
  root 'home#index'
  get "contact" => 'home#contact'
  get "about" => 'home#about'
  get "privacy" => 'home#privacy'
  
  devise_for :users, controllers: { confirmations: 'users/confirmations',
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations',
  sessions: 'users/sessions' }
  
  
  namespace :dashboard do
    get '/' => "dashboard#index"
    get 'manage/posts' => 'dashboard#manage_posts'
    post 'notification/:user_id/:notification_id'=> 'notifications#readed', as: 'notification'
    resources :categories, path:'manage/categories', except: %i[show]
    resources :posts, except: %i[show] do
      resources :comments, except: %i[show index new edit] do
        member do
          post 'like'
          post 'reply'  
        end
      end
      member do
        post 'approve_post'
        post 'reject_post'
        post 'like'
        post 'rate'
        post 'read_count'
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
