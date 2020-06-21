Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  get "/login", action: :new, controller: "sessions"
  post "/login", action: :create, controller: "sessions"
  delete "/logout", action: :destroy, controller: "sessions"

  get "/admin", action: :show, controller: "admins"

  namespace :admin do
    resources :merchants, only: [:show, :index]
    resources :users, only: [:index]
    resources :orders, only: [:update]

    resources :users, only: [:show] do
      resources :orders, only: [:show]
    end

    get '/profile/:user_id', action: :show, controller: "users"
    get "/merchants/status/:id", action: :update, controller: "merchants"
  end

  get "/merchant", action: :show, controller: "merchant" 

  namespace :merchant do
    resources :orders, only: [:show, :update]
    resources :items, except: [:show]
    get '/items/:id/status', action: :status, controller: "items"
  end

  resources :merchants

  resources :merchants, only: [:show] do
    get 'items', action: :index, controller: 'merchants_items'
    get 'items/new', action: :new, controller: 'merchants_items'
    post 'items', action: :create, controller: 'merchants_items'
  end

  resources :items, only: [:index, :show, :edit, :update, :destroy]

  resources :items, only: [:show] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  get "/cart", action: :show, controller: "cart"
  delete "/cart", action: :destroy, controller: "cart"

  namespace :cart do
    post "/:item_id", action: :new, controller: "items"
    delete "/:item_id", action: :destroy, controller: "items"
    patch "/:item_id", action: :update, controller: "items"
  end

  resources :users, only: [:create]

  get 'profile', action: :show, controller: 'users'
  get 'profile/edit', action: :edit, controller: 'users'
  post 'profile', action: :update, controller: 'users'
  get 'register', action: :new, controller: 'users'

  get "/password/edit", action: :edit, controller: "password"
  post "/password", action: :update, controller: "password"

  resources :orders, only: [:new, :create]

  resource :profile, only: [:index] do
    resources :orders, only: [:show, :index, :update]
  end

  get "error404", action: :show, controller: "errors"
end
