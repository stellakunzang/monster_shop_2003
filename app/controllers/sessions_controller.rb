class SessionsController < ApplicationController

  def new
    if current_user
      route = determine_route(current_user)

      redirect_to route
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}! You are now logged in."

      route = determine_route(user)

      redirect_to route
    else
      redirect_to "/login"
      flash[:error] = "Sorry, your credentials were incorrect."
    end
  end

  def determine_route(user)
    {
      "admin" => "/admin",
      "merchant" => "/merchant",
      "default" => "/profile"
    }[user.role]
  end
end
