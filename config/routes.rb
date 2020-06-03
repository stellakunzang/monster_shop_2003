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
    get "/merchants/disable/:id", to: "merchants#disable" # merchant update (or put in a new status controller for merchant and updating there)
    get "/merchants/enable/:id", to: "merchants#enable" # merchant update (or put in a new status controller for merchant and updating there)
    get '/users', to: 'users#index'
    get '/profile/:user_id', to: 'users#show'
    patch '/orders/:order_id', to: 'orders#update'
  end

  get "/merchant", to: "merchant#show"

  namespace :merchant do
    get '/orders/:order_id', to: 'orders#show'
    patch '/orders/:order_id', to: 'orders#update'
    get '/items', to: 'items#index'
    get '/items/:id/status', to: 'items#status'
    get '/items/:id/edit', to: 'items#edit'
    patch '/items/:id', to: 'items#update'
    delete '/items/:id', to: 'items#destroy'
    get '/items/new', to: 'items#new'
    post '/items', to: 'items#create'
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
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#destroy"

  namespace :cart do
    post "/:item_id", to: "items#new"
    delete "/:item_id", to: "items#destroy"
    patch "/:item_id", to: "items#update"
  end

  #users
  get "/login", to: "users#login"
  #we have 2 "/login" that route to different controllers...I think that means one of them isn't functioning? 

  get '/logout', to: "users#logout"

  get "/profile", to: "users#show"
  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/profile/edit", to: "users#edit"
  post "/profile", to: "users#update"

# add to a user password controller
  get "/password/edit", to: "users#edit_pass"
  post "/password", to: "users#update_pass"

  #orders
  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/profile/orders/:id", to: "orders#show"
  get "/profile/orders", to: "orders#index"
  patch "/profile/orders/:id", to: "orders#update"

  get "error404", to: "errors#show"
end
