class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}! You are now logged in."

      route = determine_route(user)

      redirect_to route
    else
      flash[:error] = "Sorry, youre not one of us."
    end
  end

  def determine_route(user)
    # WHEN YOU ARE CHECKING _DIFFERENT_ VALUES IN YOUR CONDITION
    # if (role == "admin") {
    #   # route
    # } elsif (role == "merchant") {
    #   # route
    # } elsif (role == "default") {
    #   # route
    # }

    # WHEN EACH RETURN STATEMENT DOES MORE LOGIC
    # case (role)
    # when "admin"
    #   # TODO: get right route for admin
    #   # "/admin"
    # when "merchant"
    #   "/merchants/:id"
    # when "default"
    #   "/users/:id"

    # FOR ONE TIME LOOKUP
    # KEY MATCHING TO A STATIC VALUE
    {
      "admin" => "/admin",
      "merchant" => "/merchant",
      "default" => "/profile"
    }[user.role]
  end
end
