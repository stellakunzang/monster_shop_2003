# Monster Shop: Back End Mod 2 Group Project

## Introduction

*Monster Shop* is a web application created by [Sage Lee](https://github.com/sagemlee), [Danny Ramos](https://github.com/muydanny), [Michael Gallup](https://github.com/Gallup93), & [Stella Bonnie](https://github.com/stellakunzang), students at Turing School of Software and Design. It was our final project for Mod 2 (of 4), completed 5 weeks after first encountering Rails, MVC, ActiveRecord, and RSpec.

The "Monster Shop" itself is a fictitious e-commerce platform, specializing in silly items. It is something akin to a digital flea market, hosting many different merchants who are each responsible for fulfilling their part of a customer's order. Vistors to the site must be logged-in in order to checkout. Once they enter shipping information and checkout, a merchant user is able to then fulfill their items in the order. Once all of the items from the various merchants have been marked as fulfilled, the order status is changed to "packaged." This status is visible to the customer. A third type of user, an admin or "super user", is then able to mark the order as "shipped."

This project was completed remotely, with team members utilizing Slack, Zoom, Github, and Github projects in order to collaborate and accomplish the 54 assigned user stories in a mere 10-days. As is encouraged by Turing, we relied heavily on Test Driven Development(TDD) and ActiveRecord, strived to create RESTful routes and slim controllers, and utilized Action Helper Tags in the views. Our tests are written in RSpec with Orderly, Capybara, and Should Matchers gems.

## Schema Design

When we began the project, we were pleasantly surprised to find that the schema was already populated with merchants, items, reviews, and orders. A joins table for the many-to-many relationship between items and orders was also already created. Our first addition was users, which included columns for name, address, city, state, zip code, email, password digest, and role. This was our first project with authentication and authorization, and we utilized the BCrypt gem in order to create the password digests(i.e. encrypted passwords stored in database instead of user passwords). The role utilized an enum association, with a default setting of 0 to denote a basic user.

Once we started working on the merchant user functionality (role 1), we needed a migration to associate a user with a merchant. We created a one-to-many relationship (one merchant, many employees) and a foreign_key of merchant id on the users table.

We also needed to add a column to the orders table with a status, and again used enums to associate an integer with a string (pending, packaged, shipped, or cancelled). We also realized a little further along that we would need to associate a user with an order. This was truly the most difficult migration because we had to go back and revise all of our tests and seeds to first create a user and then associate it with the orders. This relationship was also a one-to-many, with a user having many orders.

Our final migration was to add fulfillment to the item orders joins table, denoting whether a particular item in an order had been fulfilled by the merchant. A merchant user was then able to mark an order as fulfilled.

## Code Snippets

Of note, we refactored some of our model methods which were relying heavily on SQL, to simplified, streamlined ActiveRecord methods.

#### Before (SQL)

```
def self.top_5
    top_5_data = ItemOrder.find_by_sql ["SELECT items.name, item_id, SUM(quantity) AS total_purchased FROM item_orders JOIN items ON item_orders.item_id = items.id GROUP BY item_id, items.name ORDER BY total_purchased DESC LIMIT 5"]
    keys = top_5_data.pluck(:name)
    values = top_5_data.pluck(:total_purchased)
    top_5 = Hash[keys.zip(values)]
  end
```

#### After (ActiveRecord)
```
def self.top_5
  Item.joins(:item_orders)
      .where(active?: true)
      .group('items.name')
      .order('sum(item_orders.quantity) desc')
      .limit(5)
      .sum('item_orders.quantity')
end
```

We also went back once the project was completed to refactor our routes and make them more RESTful by utilizing namespacing and creating new controllers. In accordance with this refactor, we restructured our controller, view, and test file structure to incorporate more nested directories.

#### Before

```
  root 'welcome#index'

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"


  get "/login", to: "users#login"

  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/profile", to: "users#show"

end
```

#### After

```
root 'welcome#index'

 get "/login", to: "sessions#new"
 post "/login", to: "sessions#create"
 delete "/logout", to: "sessions#destroy"

 get "/admin", to: "admins#show"

 namespace :admin do
   get '/merchants/:merchant_id', to: "merchants#show"
   get '/merchants', to: "merchants#index"
   get "/merchants/status/:id", to: "merchants#update"
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

 get "/merchants", to: "merchants#index"
 get "/merchants/new", to: "merchants#new"
 get "/merchants/:id", to: "merchants#show"
 post "/merchants", to: "merchants#create"
 get "/merchants/:id/edit", to: "merchants#edit"
 patch "/merchants/:id", to: "merchants#update"
 delete "/merchants/:id", to: "merchants#destroy"

 get "/items", to: "items#index"
 get "/items/:id", to: "items#show"
 get "/items/:id/edit", to: "items#edit"
 patch "/items/:id", to: "items#update"
 delete "/items/:id", to: "items#destroy"

 get "/merchants/:merchant_id/items", to: "merchants_items#index"
 get "/merchants/:merchant_id/items/new", to: "merchants_items#new"
 post "/merchants/:merchant_id/items", to: "merchants_items#create"

 get "/items/:item_id/reviews/new", to: "reviews#new"
 post "/items/:item_id/reviews", to: "reviews#create"

 get "/reviews/:id/edit", to: "reviews#edit"
 patch "/reviews/:id", to: "reviews#update"
 delete "/reviews/:id", to: "reviews#destroy"

 get "/cart", to: "cart#show"
 delete "/cart", to: "cart#destroy"

 namespace :cart do
   post "/:item_id", to: "items#new"
   delete "/:item_id", to: "items#destroy"
   patch "/:item_id", to: "items#update"
 end

 get "/profile", to: "users#show"
 get "/register", to: "users#new"
 post "/users", to: "users#create"
 get "/profile/edit", to: "users#edit"
 post "/profile", to: "users#update"

 get "/password/edit", to: "password#edit"
 post "/password", to: "password#update"

 get "/orders/new", to: "orders#new"
 post "/orders", to: "orders#create"
 get "/profile/orders/:id", to: "orders#show"
 get "/profile/orders", to: "orders#index"
 patch "/profile/orders/:id", to: "orders#update"

 get "error404", to: "errors#show"

end
```

## Implementation Instructions

So you want to use our Monster Shop?

First you'll need these installed:

- Rails 5.1.7
_(to find out what version you are using, run `$ rails -v` in the command line)_
- Ruby 2.5.x
_(`$ ruby -v`)_

Next, clone down this repository onto your local machine.
Run these commands in order to get required gems and database established.
- `$ bundle install`
- `$ bundle update`
- `$ rake db:create`
- `$ rake db:migrate`
- `$ rake db:seed`

Once it this is all set up and you aren't getting any errors you can run our ~ * ~ adorable ~ * ~ test suite.

- `$ bundle exec rspec`

If you would rather enjoy the application on in its finished form without messing with the command line, we are hosted on Heroku [here](https://damp-hollows-38240.herokuapp.com/). You can either register as a new user and place an order, or use the login information for one of our existing test users located in our seeds (monster_shop_2003/db/seeds) to see the functionality of our merchant and admin users. Please excuse the absurdity of some of our seed items, merchants, and users. This project was executed by a team with varying backgrounds, including two graduates of film school whose creative urges and off-color sensibilities had to come out somewhere! 
