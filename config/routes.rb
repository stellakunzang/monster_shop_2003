Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/admin", to: "admins#show"

  namespace :admin do
    resources :merchants, only: [:show, :index]
    get "/merchants/status/:id", to: "merchants#update"
    resources :users, only: [:index]
    get '/profile/:user_id', to: 'users#show'
    resources :orders, only: [:update]
    resources :users, only: [:show] do
      resources :orders, only: [:show]
    end
  end

  get "/merchant", to: "merchant#show"

  namespace :merchant do
    resources :orders, only: [:show, :update]
    resources :items, except: [:show]
    get '/items/:id/status', to: 'items#status'
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

  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#destroy"

  namespace :cart do
    post "/:item_id", to: "items#new"
    delete "/:item_id", to: "items#destroy"
    patch "/:item_id", to: "items#update"
  end

  resources :users, only: [:create]

  get 'profile', action: :show, controller: 'users'
  get 'profile/edit', action: :edit, controller: 'users'
  post 'profile', action: :update, controller: 'users'
  get 'register', action: :new, controller: 'users'

  get "/password/edit", to: "password#edit"
  post "/password", to: "password#update"

  resources :orders, only: [:new, :create]

  resource :profile, only: [:index] do
    resources :orders, only: [:show, :index, :update]
  end

  get "error404", to: "errors#show"
end
