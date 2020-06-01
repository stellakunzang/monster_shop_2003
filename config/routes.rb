Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  #sessions
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/admin", to: "admins#show"

  namespace :admin do
    get '/merchants/:merchant_id', to: "merchants#show"
    get '/merchants', to: "merchants#index"
    get "/merchants/disable/:id", to: "merchants#disable"
    get "/merchants/enable/:id", to: "merchants#enable"
    get '/users', to: 'users#index'
  end

  #merchants
  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  #items
  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  #reviews
  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  #cart
  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  post "/cart/update_quantity/:item_id", to: "cart#update_quantity"

  #orders
  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"
  get "/profile/orders", to: "orders#index"
  #namespace :profile do
  #users
  get "/login", to: "users#login"
  get '/logout', to: "users#logout"
  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/profile", to: "users#show"

  get "/profile/edit", to: "users#edit"
  post "/profile", to: "users#update"
  get "/password/edit", to: "users#edit_pass"
  post "/password", to: "users#update_pass"

  #merch
  get "/merchant", to: "merchant#show"

  namespace :merchant do
    get '/orders/:order_id', to: 'orders#show'
    patch '/orders/:order_id', to: 'orders#update'
    get '/items', to: 'items#index'
  end

  get "error404", to: "errors#show"
end
